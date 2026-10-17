/**
 * Cloud Functions backend for Chief Complaint.
 *
 * Why this exists: the Flutter app never talks to Anthropic directly.
 * The API key lives only here, set with:
 *   firebase functions:secrets:set ANTHROPIC_API_KEY
 * and each callable below is only reachable by a signed-in user
 * (enforced via `request.auth` — Firebase Auth checks this for us).
 */

const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const Anthropic = require("@anthropic-ai/sdk");

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");
const MODEL = "claude-sonnet-4-6"; // pick whichever current model fits your budget

function client() {
  return new Anthropic({ apiKey: ANTHROPIC_API_KEY.value() });
}

function requireAuth(request) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
}

/** Ask the virtual patient / informant to answer the student's latest question. */
exports.patientReply = onCall({ secrets: [ANTHROPIC_API_KEY] }, async (request) => {
  requireAuth(request);
  const { patient, facts, history } = request.data;
  if (!patient || !facts || !Array.isArray(history)) {
    throw new HttpsError("invalid-argument", "Missing patient, facts, or history.");
  }

  const transcript = history.map((m) => `${m.role === "user" ? "Doctor" : "Patient"}: ${m.text}`).join("\n");
  const speakerLine = patient.informant
    ? `You are roleplaying as ${patient.informant}, giving history on behalf of the patient (${patient.name}, ${patient.age}yo ${patient.gender}).`
    : `You are roleplaying as the patient, ${patient.name}, ${patient.age}yo ${patient.gender}, ${patient.occupation}.`;

  const prompt = `${speakerLine} This is a medical training simulation. Stay fully in character, never break character, never use medical jargon, and never reveal or hint at any diagnosis.

Speaking style: a worried layman ${patient.informant ? "attendant" : "patient"} in Pakistan — mix simple Roman Urdu and simple English naturally, confused about medical terms, answers only what is asked.

Facts you know (reveal only what's relevant to what's asked, in your own words):
${facts}

Conversation so far:
${transcript}

Reply only as the patient/informant to the doctor's latest question, in 1-3 short natural sentences. No stage directions.`;

  const msg = await client().messages.create({
    model: MODEL,
    max_tokens: 300,
    messages: [{ role: "user", content: prompt }],
  });

  return { reply: msg.content.find((b) => b.type === "text")?.text?.trim() ?? "..." };
});

/** Grade the finished case: history quality, diagnosis, and prescription. */
exports.gradeCase = onCall({ secrets: [ANTHROPIC_API_KEY] }, async (request) => {
  requireAuth(request);
  const { idealDiagnosis, idealManagement, transcript, diagnosis, prescription } = request.data;

  const prompt = `You are an expert clinical examiner grading a medical student on a simulated OPD case.

Ideal diagnosis: ${idealDiagnosis}
Ideal management: ${idealManagement}

Student's history-taking transcript:
${transcript || "(no questions were asked)"}

Student's submitted diagnosis: "${diagnosis}"
Student's submitted prescription/management plan: "${prescription}"

Grade strictly but fairly and constructively, as a clinical tutor would. Return ONLY valid JSON, no markdown fences, with exactly this shape:
{"historyScore": number 0-10, "historyFeedback": string (2-3 sentences), "diagnosisScore": number 0-10, "diagnosisFeedback": string (2-3 sentences), "rxScore": number 0-10, "rxFeedback": string (2-3 sentences), "overallFeedback": string (2-4 sentences)}`;

  const msg = await client().messages.create({
    model: MODEL,
    max_tokens: 700,
    messages: [{ role: "user", content: prompt }],
  });

  const raw = msg.content.find((b) => b.type === "text")?.text ?? "{}";
  try {
    return JSON.parse(raw.replace(/```json|```/g, "").trim());
  } catch (e) {
    throw new HttpsError("internal", "Could not parse grading response.");
  }
});

/** Answer a student's follow-up question about an MCQ's explanation. */
exports.mcqFollowup = onCall({ secrets: [ANTHROPIC_API_KEY] }, async (request) => {
  requireAuth(request);
  const { question, options, correctIndex, explanation, priorChat, newQuestion } = request.data;

  const history = (priorChat || []).map((c) => `${c.role === "user" ? "Student" : "Tutor"}: ${c.text}`).join("\n");
  const prompt = `You are a friendly, precise clinical tutor helping a medical student understand an MCQ explanation. Keep answers concise (2-5 sentences), teaching-style, and grounded in the question below.

Question: ${question}
Options: ${options.map((o, i) => String.fromCharCode(65 + i) + ") " + o).join(" | ")}
Correct answer: ${String.fromCharCode(65 + correctIndex)}) ${options[correctIndex]}
Explanation given: ${explanation}

Prior follow-up conversation:
${history || "(none yet)"}

Student's new question: "${newQuestion}"
Answer the student's question directly.`;

  const msg = await client().messages.create({
    model: MODEL,
    max_tokens: 400,
    messages: [{ role: "user", content: prompt }],
  });

  return { reply: msg.content.find((b) => b.type === "text")?.text?.trim() ?? "..." };
});
