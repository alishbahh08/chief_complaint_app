const JWKS_URL =
    "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";

const CORS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Authorization, Content-Type",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(data, status = 200) {
    return new Response(JSON.stringify(data), {
        status,
        headers: { "Content-Type": "application/json", ...CORS },
    });
}

/* ---------- Firebase ID token verification ---------- */

function b64urlToBytes(s) {
    s = s.replace(/-/g, "+").replace(/_/g, "/");
    s += "=".repeat((4 - (s.length % 4)) % 4);
    return Uint8Array.from(atob(s), (c) => c.charCodeAt(0));
}
function b64urlToJson(s) {
    return JSON.parse(new TextDecoder().decode(b64urlToBytes(s)));
}

async function verifyFirebaseToken(token, projectId) {
    const parts = token.split(".");
    if (parts.length !== 3) throw new Error("Malformed token");
    const header = b64urlToJson(parts[0]);
    const payload = b64urlToJson(parts[1]);
    if (header.alg !== "RS256") throw new Error("Bad alg");

    const res = await fetch(JWKS_URL, { cf: { cacheTtl: 3600, cacheEverything: true } });
    const { keys } = await res.json();
    const jwk = keys.find((k) => k.kid === header.kid);
    if (!jwk) throw new Error("Unknown key");

    const key = await crypto.subtle.importKey(
        "jwk", jwk, { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" }, false, ["verify"]
    );
    const ok = await crypto.subtle.verify(
        "RSASSA-PKCS1-v1_5", key,
        b64urlToBytes(parts[2]),
        new TextEncoder().encode(parts[0] + "." + parts[1])
    );
    if (!ok) throw new Error("Bad signature");

    const now = Math.floor(Date.now() / 1000);
    if (payload.exp < now) throw new Error("Token expired");
    if (payload.iat > now + 300) throw new Error("Token issued in future");
    if (payload.aud !== projectId) throw new Error("Wrong audience");
    if (payload.iss !== "https://securetoken.google.com/" + projectId) throw new Error("Wrong issuer");
    if (!payload.sub) throw new Error("No subject");
    return payload;
}

/* ---------- Groq ---------- */

async function groq(env, prompt, maxTokens, jsonMode = false) {
    const body = {
        model: env.GROQ_MODEL,
        max_tokens: maxTokens * 4,
        reasoning_effort: "low",
        temperature: jsonMode ? 0.2 : 0.7,
        messages: [{ role: "user", content: prompt }],
    };
    if (jsonMode) body.response_format = { type: "json_object" };

    const res = await fetch("https://api.groq.com/openai/v1/chat/completions", {
        method: "POST",
        headers: {
            Authorization: "Bearer " + env.GROQ_API_KEY,
            "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
    });
    if (!res.ok) throw new Error("Groq error " + res.status + ": " + (await res.text()));
    const data = await res.json();
    return data.choices?.[0]?.message?.content?.trim() ?? "";
}

/* ---------- Handlers ---------- */

async function patientReply(env, d) {
    const { patient, facts, history } = d;
    if (!patient || !facts || !Array.isArray(history)) {
        return json({ error: "Missing patient, facts, or history." }, 400);
    }
    const transcript = history
        .map((m) => `${m.role === "user" ? "Doctor" : "Patient"}: ${m.text}`)
        .join("\n");
    const speakerLine = patient.informant
        ? `You are roleplaying as ${patient.informant}, giving history on behalf of the patient (${patient.name}, ${patient.age}yo ${patient.gender}).`
        : `You are roleplaying as the patient, ${patient.name}, ${patient.age}yo ${patient.gender}, ${patient.occupation}.`;

    const prompt = `${speakerLine} This is a medical training simulation. Stay fully in character, never break character, never use medical jargon, and never reveal or hint at any diagnosis.

Speaking style: a worried layman ${patient.informant ? "attendant" : "patient"} in Pakistan - mix simple Roman Urdu and simple English naturally, confused about medical terms, answers only what is asked.

Facts you know (reveal only what's relevant to what's asked, in your own words):
${facts}

Conversation so far:
${transcript}

Reply only as the patient/informant to the doctor's latest question, in 1-3 short natural sentences. No stage directions.`;

    const reply = await groq(env, prompt, 300);
    return json({ reply: reply || "..." });
}

async function gradeCase(env, d) {
    const { idealDiagnosis, idealManagement, transcript, diagnosis, prescription } = d;
    const prompt = `You are an expert clinical examiner grading a medical student on a simulated OPD case.

Ideal diagnosis: ${idealDiagnosis}
Ideal management: ${idealManagement}

Student's history-taking transcript:
${transcript || "(no questions were asked)"}

Student's submitted diagnosis: "${diagnosis}"
Student's submitted prescription/management plan: "${prescription}"

Grade strictly but fairly and constructively, as a clinical tutor would. Return ONLY valid JSON, no markdown fences, with exactly this shape:
{"historyScore": number 0-10, "historyFeedback": string (2-3 sentences), "diagnosisScore": number 0-10, "diagnosisFeedback": string (2-3 sentences), "rxScore": number 0-10, "rxFeedback": string (2-3 sentences), "overallFeedback": string (2-4 sentences)}`;

    const raw = await groq(env, prompt, 700, true);
    try {
        return json(JSON.parse(raw.replace(/```json|```/g, "").trim()));
    } catch (e) {
        return json({ error: "Could not parse grading response." }, 500);
    }
}

async function mcqFollowup(env, d) {
    const { question, options, correctIndex, explanation, priorChat, newQuestion } = d;
    if (!Array.isArray(options)) return json({ error: "Missing options." }, 400);

    const history = (priorChat || [])
        .map((c) => `${c.role === "user" ? "Student" : "Tutor"}: ${c.text}`)
        .join("\n");
    const prompt = `You are a friendly, precise clinical tutor helping a medical student understand an MCQ explanation. Keep answers concise (2-5 sentences), teaching-style, and grounded in the question below.

Question: ${question}
Options: ${options.map((o, i) => String.fromCharCode(65 + i) + ") " + o).join(" | ")}
Correct answer: ${String.fromCharCode(65 + correctIndex)}) ${options[correctIndex]}
Explanation given: ${explanation}

Prior follow-up conversation:
${history || "(none yet)"}

Student's new question: "${newQuestion}"
Answer the student's question directly.`;

    const reply = await groq(env, prompt, 400);
    return json({ reply: reply || "..." });
}

async function generateCase(env, d) {
    const topic = String(d.topic || "").trim().slice(0, 200);
    const specialty = String(d.specialty || "").trim().slice(0, 60);
    if (!topic) return json({ error: "Missing topic." }, 400);

    const prompt = `You are a clinical educator building a realistic OPD teaching case for MBBS students in Pakistan.
Topic/diagnosis: ${topic}
Specialty: ${specialty || "choose the most fitting one"}

Return ONLY a valid JSON object, no markdown fences, with exactly these keys:
{
 "title": string (a symptom-based title that does NOT reveal the diagnosis),
 "teaser": string (one sentence, no diagnosis),
 "specialty": string,
 "patientName": string (realistic Pakistani name),
 "patientAge": integer,
 "patientGender": "Male" or "Female",
 "patientOccupation": string,
 "informant": string or null (e.g. "Mother" for young children, otherwise null),
 "vitals": {"HR": "98 bpm", "BP": "112/72 mmHg", "Temp": "38.4 C", "RR": "20/min", "SpO2": "98%"} (consistent with the case),
 "opening": string (the patient's opening complaint in simple layman Roman Urdu mixed with simple English, 1-3 sentences, no medical jargon, no diagnosis),
 "facts": string (private history facts for the AI patient, as lines starting with "- ": onset, duration, character, associated symptoms, negatives, past/drug/family/social history. The LAST line must be: "- If asked something not covered here, answer vaguely and plausibly like a real worried patient, never contradict the facts above, never mention a diagnosis."),
 "exam": [{"label": string, "finding": string}] (8-12 items, including relevant and irrelevant/normal ones),
 "idealExam": [string] (labels copied EXACTLY from exam, the essential ones),
 "investigations": [{"label": string, "finding": string}] (6-10 items, including some unnecessary ones),
 "idealIx": [string] (labels copied EXACTLY from investigations, the essential ones),
 "idealDiagnosis": string,
 "idealManagement": string (practical, guideline-style, with drug names and doses where appropriate for an adult/child as per the case)
}`;

    const raw = await groq(env, prompt, 1800, true);
    try {
        const obj = JSON.parse(raw.replace(/```json|```/g, "").trim());
        if (!Array.isArray(obj.exam)) obj.exam = [];
        if (!Array.isArray(obj.investigations)) obj.investigations = [];
        if (!Array.isArray(obj.idealExam)) obj.idealExam = [];
        if (!Array.isArray(obj.idealIx)) obj.idealIx = [];
        return json(obj);
    } catch (e) {
        return json({ error: "Could not parse generated case." }, 500);
    }
}

async function generateMcqs(env, d) {
    const notes = String(d.notes || "").trim().slice(0, 12000);
    const specialty = String(d.specialty || "").trim().slice(0, 60);
    const count = Math.max(1, Math.min(15, parseInt(d.count, 10) || 10));
    if (notes.length < 40) return json({ error: "Notes are too short." }, 400);

    const prompt = `You are an MBBS examiner writing single-best-answer MCQs from a student's lecture notes.
Specialty: ${specialty || "general"}
Write exactly ${count} MCQs based ONLY on the notes below. Each must have 4 plausible options, exactly one correct, and a short explanation (2-3 sentences) of why it is correct and why the main distractor is wrong.

Notes:
"""
${notes}
"""

Return ONLY valid JSON, no markdown fences, with exactly this shape:
{"mcqs": [{"question": string, "options": [string, string, string, string], "correctIndex": integer 0-3, "explanation": string}]}`;

    const raw = await groq(env, prompt, 2500, true);
    try {
        const obj = JSON.parse(raw.replace(/```json|```/g, "").trim());
        const mcqs = (obj.mcqs || []).filter(
            (m) => m && m.question && Array.isArray(m.options) && m.options.length === 4 &&
                Number.isInteger(m.correctIndex) && m.correctIndex >= 0 && m.correctIndex <= 3
        );
        if (!mcqs.length) return json({ error: "No valid MCQs generated." }, 500);
        return json({ mcqs });
    } catch (e) {
        return json({ error: "Could not parse generated MCQs." }, 500);
    }
}

const ROUTES = {
    "/patientReply": patientReply,
    "/gradeCase": gradeCase,
    "/mcqFollowup": mcqFollowup,
    "/generateCase": generateCase,
    "/generateMcqs": generateMcqs,
};

export default {
    async fetch(request, env) {
        if (request.method === "OPTIONS") return new Response(null, { headers: CORS });
        if (request.method !== "POST") return json({ error: "POST only" }, 405);

        const handler = ROUTES[new URL(request.url).pathname];
        if (!handler) return json({ error: "Not found" }, 404);

        const auth = request.headers.get("Authorization") || "";
        if (!auth.startsWith("Bearer ")) return json({ error: "Sign in required." }, 401);
        try {
            await verifyFirebaseToken(auth.slice(7), env.FIREBASE_PROJECT_ID);
        } catch (e) {
            return json({ error: "Invalid token: " + e.message }, 401);
        }

        try {
            return await handler(env, await request.json());
        } catch (e) {
            return json({ error: "Server error: " + e.message }, 500);
        }
    },
};
