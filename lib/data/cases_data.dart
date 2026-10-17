// GENERATED from the web prototype's case data. Edit here or regenerate from chief-complaint.html.
import '../models/case_model.dart';

final List<CaseModel> allCases = [
  const CaseModel(
    id: 'appendicitis',
    specialty: 'Surgery',
    title: 'Acute abdominal pain',
    teaser:
        'A young married woman presents with a couple of days of abdominal pain that has been shifting location.',
    patientName: 'Ayesha Bibi',
    patientAge: 23,
    patientGender: 'Female',
    patientOccupation: 'Housewife',
    informant: null,
    vitals: {
      'HR': '98 bpm',
      'BP': '112/72 mmHg',
      'Temp': '38.4°C',
      'RR': '20/min',
      'SpO2': '98%'
    },
    opening:
        'Doctor sahab, mujhe do teen din se pait mein bara dard ho raha hai... pehle nabhi ke aas paas tha, ab neeche daaine taraf chala gaya hai. Bukhar bhi hai kal se, aur kuch khaya nahi ja raha, bohat pareshaan hun.',
    facts:
        '\n- Pain started 2 days ago, first around the navel, now moved and settled in the lower right side of the belly.\n- Pain was dull at first, now sharp and constant, about 7/10 severity.\n- Worse with walking, coughing, or pressing on it; better lying still with knees bent.\n- Nausea present, vomited once yesterday. No appetite since yesterday.\n- Mild fever since yesterday evening, felt hot, did not measure at home.\n- No diarrhea. Maybe slightly constipated last two days. No blood in stool.\n- No burning or frequency in urination.\n- Last menstrual period was about 2 weeks ago, cycles normally regular. Has not taken any pregnancy test.\n- Married about 1 year ago, no children yet. Husband works as a driver.\n- No previous surgeries. No similar pain episodes before. No known chronic illness.\n- Scared it might be "appendix wala masla" because a neighbour had something similar, but does not know what is actually wrong.\n- If asked something not covered here, answer vaguely and plausibly like a real worried patient (e.g. "pata nahi doctor sahab"), never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Patient lying still, avoiding movement, mild distress on face. Not pale, not jaundiced.'),
      CaseItem('Vitals recheck',
          'HR 98 bpm, BP 112/72 mmHg, Temp 38.4°C, RR 20/min, SpO2 98%.'),
      CaseItem('Abdominal inspection',
          'Abdomen not distended, moves with respiration, no visible scars or masses.'),
      CaseItem('Superficial palpation',
          'Mild guarding localized to the right iliac fossa. Rest of the abdomen soft, non-tender.'),
      CaseItem('Deep palpation – McBurney\'s point',
          'Marked tenderness at McBurney\'s point.'),
      CaseItem('Rovsing\'s sign',
          'Positive — palpating the left iliac fossa produces pain in the right iliac fossa.'),
      CaseItem('Psoas sign',
          'Positive — pain on passive extension of the right hip.'),
      CaseItem('Obturator sign', 'Negative.'),
      CaseItem('Rebound tenderness (Blumberg sign)',
          'Positive — pain worse on sudden release of pressure over the right iliac fossa.'),
      CaseItem('Auscultation – bowel sounds',
          'Bowel sounds present, slightly reduced in frequency.'),
      CaseItem('Hernial orifices',
          'No swelling or tenderness at either hernial orifice.'),
      CaseItem('Digital rectal exam',
          'Deferred — not indicated as a first step given the clear findings above.'),
    ],
    idealExam: [
      'Vitals recheck',
      'Superficial palpation',
      'Deep palpation – McBurney\'s point',
      'Rovsing\'s sign',
      'Rebound tenderness (Blumberg sign)',
      'Auscultation – bowel sounds'
    ],
    investigations: [
      CaseItem('CBC (Complete Blood Count)',
          'WBC 14,200/µL (raised), neutrophils 82%. Hb 12.1 g/dL, platelets normal.'),
      CaseItem('CRP', 'Raised at 38 mg/L (normal <10).'),
      CaseItem('Urine R/E',
          'No pus cells, no nitrites, no RBCs — urinary infection unlikely.'),
      CaseItem('Urine pregnancy test (β-hCG)', 'Negative.'),
      CaseItem('Ultrasound abdomen/pelvis',
          'Non-compressible, blind-ending tubular structure in the right iliac fossa, diameter 9mm, wall thickened, peri-appendiceal fat stranding. No free fluid. Both ovaries normal.'),
      CaseItem('Serum amylase/lipase', 'Within normal limits.'),
      CaseItem('LFTs', 'Within normal limits.'),
      CaseItem('CT abdomen (contrast)',
          'Not performed — ultrasound was already diagnostic.'),
    ],
    idealIx: [
      'CBC (Complete Blood Count)',
      'Urine R/E',
      'Urine pregnancy test (β-hCG)',
      'Ultrasound abdomen/pelvis'
    ],
    idealDiagnosis: 'Acute appendicitis',
    idealManagement:
        'NPO, IV fluids, IV antibiotics (e.g. ceftriaxone + metronidazole), analgesia, and urgent surgical referral for appendectomy with informed consent. Differentials to exclude: ectopic pregnancy, ovarian cyst/torsion, UTI, mesenteric adenitis.',
  ),
  const CaseModel(
    id: 'typhoid',
    specialty: 'Medicine',
    title: 'Prolonged fever',
    teaser:
        'A teenage boy has had a rising fever for about a week that isn\'t settling with usual medicines.',
    patientName: 'Kamran Ali',
    patientAge: 19,
    patientGender: 'Male',
    patientOccupation: 'Student',
    informant: null,
    vitals: {
      'HR': '102 bpm',
      'BP': '100/64 mmHg',
      'Temp': '39.6°C',
      'RR': '20/min',
      'SpO2': '98%'
    },
    opening:
        'Doctor sahab mujhe pichlay 6-7 dinon se bukhar aa raha hai, roz shaam ko barh jata hai... sar bhi dukhta hai aur kuch khane ko dil nahi karta.',
    facts:
        '\n- Fever started about 7 days ago, gradually increasing day by day (stepladder pattern), worse in the evenings, milder in mornings.\n- Associated headache and generalized body aches, feels weak and tired.\n- Mild diffuse abdominal discomfort. Was mildly constipated the first few days, now has loose stools 2-3 times/day for the last 2 days.\n- Decreased appetite.\n- Has not noticed any rash himself.\n- No burning or frequency in urination.\n- Often eats from a roadside food stall near his college; recalls a couple of classmates also being sick with fever recently.\n- No travel outside the city. No prior similar illness. No known chronic disease.\n- Does not know if he was ever vaccinated against typhoid.\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Looks unwell and lethargic, dry lips, slow to respond to questions.'),
      CaseItem('Vitals recheck',
          'Temp 39.6°C, HR 102 bpm — pulse rise is relatively less than expected for this fever (relative bradycardia). BP 100/64, RR 20.'),
      CaseItem('Abdominal examination',
          'Mild diffuse tenderness, no rigidity, no localized guarding.'),
      CaseItem('Hepatosplenomegaly check',
          'Mild splenomegaly palpable just below the left costal margin. Liver not enlarged.'),
      CaseItem('Skin examination – rose spots',
          'A few faint pink, blanching macules noted on the trunk.'),
      CaseItem('Tongue examination',
          'Coated tongue with red tip and edges ("typhoid tongue").'),
      CaseItem('Chest auscultation', 'Clear bilaterally, no crackles.'),
      CaseItem('Lymph node examination', 'No significant lymphadenopathy.'),
    ],
    idealExam: [
      'Vitals recheck',
      'Abdominal examination',
      'Hepatosplenomegaly check',
      'Skin examination – rose spots',
      'Tongue examination'
    ],
    investigations: [
      CaseItem('CBC (Complete Blood Count)',
          'Mild leukopenia with relative lymphocytosis, mild anemia.'),
      CaseItem('Widal test',
          'O and H antibody titres elevated — supportive but not confirmatory (limited specificity).'),
      CaseItem('Blood culture',
          'Positive for Salmonella Typhi — this is the confirmatory/gold-standard test.'),
      CaseItem('Stool R/E', 'No ova or cysts seen, occult blood negative.'),
      CaseItem('Urine R/E', 'Normal.'),
      CaseItem('LFTs', 'Mildly deranged transaminases.'),
      CaseItem('CRP', 'Raised.'),
    ],
    idealIx: ['CBC (Complete Blood Count)', 'Blood culture', 'LFTs'],
    idealDiagnosis: 'Enteric fever (typhoid fever)',
    idealManagement:
        'Empirical IV/oral antibiotics (e.g. ceftriaxone or azithromycin depending on severity and local resistance), antipyretics, adequate hydration, soft easily digestible diet, monitor for complications (GI bleed/perforation), confirm with blood culture, admit if toxic or complicated, counsel on safe food/water hygiene.',
  ),
  const CaseModel(
    id: 'tonsillitis',
    specialty: 'ENT',
    title: 'Sore throat and fever',
    teaser:
        'A teenager presents with a painful throat, difficulty swallowing, and fever for a few days.',
    patientName: 'Hassan Raza',
    patientAge: 16,
    patientGender: 'Male',
    patientOccupation: 'Student',
    informant: null,
    vitals: {
      'HR': '92 bpm',
      'BP': '110/70 mmHg',
      'Temp': '38.8°C',
      'RR': '18/min',
      'SpO2': '99%'
    },
    opening:
        'Doctor sahab mera gala bohat dukh raha hai, khana nigalna mushkil ho raha hai, aur bukhar bhi hai.',
    facts:
        '\n- Sore throat for 3 days, gradually worsening, pain worse on swallowing (odynophagia).\n- Fever for the last 2 days.\n- No cough, no runny/blocked nose.\n- Mild ear pain (referred), no hearing loss.\n- Feels swollen glands in the neck, tender to his own touch.\n- No difficulty breathing, no drooling, voice sounds normal (not muffled).\n- No rash, no joint pains.\n- No previous recurrent throat infections that he recalls. No smoking. No known allergies.\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Uncomfortable, mild distress from throat pain, no stridor, voice normal (not muffled).'),
      CaseItem('Vitals recheck',
          'Temp 38.8°C, HR 92 bpm, BP 110/70, RR 18, SpO2 99%.'),
      CaseItem('Oropharyngeal examination',
          'Tonsils enlarged and erythematous with white/yellow exudate bilaterally.'),
      CaseItem('Neck examination',
          'Tender, enlarged anterior cervical lymph nodes bilaterally.'),
      CaseItem('Ear examination (otoscopy)',
          'Tympanic membranes normal bilaterally.'),
      CaseItem('Check for trismus / uvula deviation',
          'None — uvula central, mouth opens fully. Argues against a peritonsillar abscess.'),
    ],
    idealExam: [
      'Vitals recheck',
      'Oropharyngeal examination',
      'Neck examination',
      'Check for trismus / uvula deviation'
    ],
    investigations: [
      CaseItem('Rapid streptococcal antigen test / throat swab',
          'Positive for Group A Streptococcus.'),
      CaseItem(
          'CBC (Complete Blood Count)', 'Mild leukocytosis with neutrophilia.'),
      CaseItem('CRP', 'Mildly raised.'),
    ],
    idealIx: [
      'Rapid streptococcal antigen test / throat swab',
      'CBC (Complete Blood Count)'
    ],
    idealDiagnosis: 'Acute bacterial (streptococcal) tonsillopharyngitis',
    idealManagement:
        'Full course of oral antibiotics (e.g. Penicillin V or Amoxicillin; Azithromycin if penicillin-allergic) to reduce complications like rheumatic fever/glomerulonephritis, paracetamol for pain/fever, warm saline gargles, adequate hydration and soft diet, safety-net advice to return urgently if drooling, muffled voice, trismus, or breathing difficulty develop (peritonsillar abscess).',
  ),
  const CaseModel(
    id: 'preeclampsia',
    specialty: 'Obstetrics & Gynaecology',
    title: 'Headache in pregnancy',
    teaser:
        'A pregnant woman at 32 weeks presents with headache, visual symptoms, and swelling.',
    patientName: 'Sana Tariq',
    patientAge: 28,
    patientGender: 'Female',
    patientOccupation: 'G2P1, 32 weeks pregnant',
    informant: null,
    vitals: {
      'HR': '88 bpm',
      'BP': '158/102 mmHg',
      'Temp': '37.0°C',
      'RR': '18/min',
      'SpO2': '98%'
    },
    opening:
        'Doctor sahab mera sar bohat dukh raha hai do din se, aankhon ke agay chamak si aati hai, aur haath pair bhi phool gaye hain.',
    facts:
        '\n- 32 weeks pregnant, second pregnancy (first child alive and well).\n- Frontal headache for 2 days, not relieved by usual measures like rest.\n- Occasional visual disturbances — flashing lights and blurring.\n- Swelling of hands and feet, worse than usual for this pregnancy, increasing over the past week.\n- Mild epigastric/right upper abdominal discomfort, denies severe pain.\n- No vaginal bleeding, no leaking fluid, feels baby\'s movements normally.\n- No fever, no burning on urination.\n- Antenatal checkups mostly regular; last visit her BP was noted as "a bit high" but nothing was started.\n- No known chronic hypertension or diabetes before this pregnancy.\n- Vaguely recalls her mother had "BP problem" during her own pregnancies.\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('Vitals recheck',
          'BP 158/102 mmHg (repeat confirms hypertension), HR 88, Temp 37.0°C, RR 18.'),
      CaseItem('Pedal edema check',
          'Pitting edema up to the shins, mild facial puffiness also noted.'),
      CaseItem('Reflexes (patellar)',
          'Brisk reflexes with a couple of beats of clonus.'),
      CaseItem('Obstetric abdominal examination',
          'Fundal height corresponds to dates, fetal heart sounds present and normal, no uterine tenderness.'),
      CaseItem('Epigastric / RUQ tenderness check',
          'Mild tenderness present in the right upper quadrant/epigastrium.'),
    ],
    idealExam: [
      'Vitals recheck',
      'Pedal edema check',
      'Reflexes (patellar)',
      'Epigastric / RUQ tenderness check'
    ],
    investigations: [
      CaseItem('Urine dipstick for protein', '2+ proteinuria.'),
      CaseItem('Spot urine protein-creatinine ratio',
          'Elevated, consistent with significant proteinuria.'),
      CaseItem('CBC with platelet count', 'Platelet count mildly low.'),
      CaseItem('LFTs', 'Mildly raised transaminases.'),
      CaseItem('Renal function tests (urea/creatinine)', 'Mildly elevated.'),
      CaseItem('Ultrasound with fetal Doppler',
          'Fetus appropriate for gestational age, dopplers currently normal.'),
    ],
    idealIx: [
      'Urine dipstick for protein',
      'CBC with platelet count',
      'LFTs',
      'Renal function tests (urea/creatinine)'
    ],
    idealDiagnosis: 'Pre-eclampsia (severity features to be assessed)',
    idealManagement:
        'Urgent obstetric referral/admission for close monitoring, antihypertensives if BP persistently ≥160/110 (e.g. labetalol or nifedipine), magnesium sulfate for seizure prophylaxis if severe features/impending eclampsia, fetal monitoring (CTG, growth scans), corticosteroids for fetal lung maturity if preterm delivery anticipated, plan timed delivery based on severity and gestational age.',
  ),
  const CaseModel(
    id: 'gastroenteritis',
    specialty: 'Pediatrics',
    title: 'Vomiting and loose motions in a child',
    teaser:
        'A 4-year-old boy is brought in by his mother with vomiting and diarrhea for two days.',
    patientName: 'Ali',
    patientAge: 4,
    patientGender: 'Male',
    patientOccupation: 'Preschool-age child',
    informant: 'Ali\'s mother, Nasreen Bibi (26yo)',
    vitals: {
      'HR': '128 bpm',
      'BP': '90/56 mmHg',
      'Temp': '37.8°C',
      'RR': '30/min',
      'SpO2': '97%'
    },
    opening:
        'Doctor sahab, mera beta do din se ulti aur dast kar raha hai, bohat kamzor lag raha hai, pani bhi thik se nahi pi raha.',
    facts:
        '\n- Vomiting and watery loose stools for 2 days, about 5-6 times a day.\n- No blood or mucus noticed in the stool.\n- Mild on-and-off fever.\n- Mother has noticed fewer wet diapers / less frequent urination than usual.\n- Child seems less playful and a bit lethargic at times, but is consolable and recognizes his mother.\n- Poor oral intake — refusing feeds partly, but drinks a little when offered.\n- No cough or cold symptoms.\n- Immunizations are up to date as far as the mother knows.\n- Gave him a bit of ORS once at home but he vomited it back up.\n- No similar illness before, no chronic disease. Other family members at home are fine.\n- If asked something not covered here, answer vaguely and plausibly as a worried mother would, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Child looks irritable and mildly lethargic, sunken eyes noted, but rousable and consolable.'),
      CaseItem('Vitals recheck',
          'HR 128 bpm, RR 30/min, Temp 37.8°C, BP 90/56 mmHg, SpO2 97%.'),
      CaseItem('Skin turgor',
          'Reduced skin turgor — a skin pinch on the abdomen goes back slowly.'),
      CaseItem('Mucous membranes', 'Dry lips and dry oral mucosa/tongue.'),
      CaseItem(
          'Capillary refill time', 'Mildly prolonged, around 2-3 seconds.'),
      CaseItem('Abdominal examination',
          'Soft, mildly distended, no rigidity, bowel sounds hyperactive.'),
      CaseItem('Weight check',
          'Weight is at the lower end of the expected range for age.'),
    ],
    idealExam: [
      'Vitals recheck',
      'Skin turgor',
      'Mucous membranes',
      'Capillary refill time',
      'Abdominal examination'
    ],
    investigations: [
      CaseItem('Serum electrolytes',
          'Mild hyponatremia (Na 133 mmol/L), K 3.6 mmol/L.'),
      CaseItem('Blood urea/creatinine',
          'Mildly raised, consistent with dehydration (pre-renal).'),
      CaseItem('Stool R/E',
          'No blood, no ova/cysts; occasional pus cells, favouring a viral cause.'),
      CaseItem('Random blood glucose', 'Within normal limits.'),
      CaseItem('CBC (Complete Blood Count)',
          'Mild leukocytosis, otherwise unremarkable.'),
    ],
    idealIx: ['Serum electrolytes', 'Blood urea/creatinine', 'Stool R/E'],
    idealDiagnosis: 'Acute gastroenteritis with moderate dehydration',
    idealManagement:
        'Assess and classify dehydration severity; give Oral Rehydration Solution (ORS) for moderate dehydration (IV fluids if unable to tolerate orally or if severe dehydration), continue age-appropriate feeding/breastfeeding, zinc supplementation, monitor urine output and hydration status closely, educate the caregiver on red-flag symptoms (persistent vomiting, no urine output, increasing lethargy) to return immediately, avoid unnecessary antibiotics since most cases are viral.',
  ),
  const CaseModel(
    id: 'ankle_fracture',
    specialty: 'Orthopaedics',
    title: 'Twisted ankle after a fall',
    teaser:
        'A young laborer presents a day after twisting his ankle while playing cricket.',
    patientName: 'Bilal Khan',
    patientAge: 27,
    patientGender: 'Male',
    patientOccupation: 'Laborer',
    informant: null,
    vitals: {
      'HR': '88 bpm',
      'BP': '122/78 mmHg',
      'Temp': '37.0°C',
      'RR': '16/min',
      'SpO2': '99%'
    },
    opening:
        'Doctor sahab, kal cricket khelte hue pair mudh gaya, ab chalna mushkil hai aur bohat soojan hai.',
    facts:
        '\n- Injured yesterday while running during a cricket match — twisted the ankle inward (inversion injury).\n- Immediate pain and swelling started right after the injury.\n- Has been unable to bear weight properly on that foot since.\n- Recalls hearing a "pop" sound at the time of injury.\n- No other injuries, no head injury, no loss of consciousness.\n- Pain is worse with movement, some relief with rest and ice at home.\n- No previous injury to this ankle, no chronic joint disease.\n- No numbness or tingling in the foot; can wiggle his toes.\n- Worried about missing work since he is a laborer.\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Limping, avoiding weight-bearing on the affected foot.'),
      CaseItem('Local inspection of ankle',
          'Swelling and bruising visible over the lateral ankle.'),
      CaseItem('Palpation',
          'Tenderness over the lateral malleolus and along the distal fibula.'),
      CaseItem('Ottawa ankle rules check',
          'Point tenderness at the posterior edge/tip of the lateral malleolus, plus inability to bear weight both immediately after injury and now — X-ray is indicated.'),
      CaseItem('Range of motion',
          'Painful and restricted dorsiflexion and plantarflexion.'),
      CaseItem('Distal neurovascular exam',
          'Dorsalis pedis pulse palpable, sensation intact, normal capillary refill in the toes.'),
    ],
    idealExam: [
      'Local inspection of ankle',
      'Palpation',
      'Ottawa ankle rules check',
      'Distal neurovascular exam'
    ],
    investigations: [
      CaseItem('X-ray ankle (AP, lateral, mortise views)',
          'Non-displaced fracture of the distal fibula (lateral malleolus); ankle mortise intact.'),
      CaseItem('X-ray foot',
          'Not indicated based on examination findings — no foot tenderness.'),
    ],
    idealIx: ['X-ray ankle (AP, lateral, mortise views)'],
    idealDiagnosis: 'Non-displaced distal fibular (lateral malleolus) fracture',
    idealManagement:
        'Immobilize in a below-knee backslab/cast or ankle brace depending on stability, analgesia (NSAIDs/paracetamol), RICE principles (rest, ice, compression, elevation), protected/non-weight-bearing as advised, follow-up X-ray to assess healing, orthopedic referral if displaced or unstable, safety-net advice about numbness or worsening pain.',
  ),
  const CaseModel(
    id: 'scabies',
    specialty: 'Dermatology',
    title: 'Itchy skin rash',
    teaser:
        'A hostel-residing student presents with two weeks of intense itching, worse at night.',
    patientName: 'Fatima',
    patientAge: 19,
    patientGender: 'Female',
    patientOccupation: 'Student, living in a hostel',
    informant: null,
    vitals: {
      'HR': '78 bpm',
      'BP': '110/70 mmHg',
      'Temp': '36.8°C',
      'RR': '16/min',
      'SpO2': '99%'
    },
    opening:
        'Doctor sahab mujhe pichlay do hafton se jism par bohat khujli ho rahi hai, khaas kar raat ko bohat zyada hoti hai.',
    facts:
        '\n- Itching for about 2 weeks, clearly worse at night.\n- Small red bumps and thin lines noticed especially between the fingers, on the wrists, and around the waistline.\n- A few of her hostel roommates have had similar itching recently.\n- No fever or other systemic symptoms.\n- Tried an over-the-counter itch cream with minimal relief.\n- No new soaps, detergents, or cosmetics recently that she can recall.\n- No known allergies, no chronic skin disease before.\n- Has been scratching a lot; some areas now look infected ("kuch jagah se paani nikal raha hai").\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection',
          'Visible scratch marks (excoriations) over the trunk and limbs.'),
      CaseItem('Skin exam – web spaces of fingers',
          'Thin greyish burrows visible between several fingers.'),
      CaseItem('Skin exam – wrists/waistline',
          'Papular rash with excoriations along the wrists and waistband area.'),
      CaseItem('Skin exam – signs of secondary infection',
          'A couple of lesions show crusting and pus, suggestive of secondary bacterial infection.'),
    ],
    idealExam: [
      'Skin exam – web spaces of fingers',
      'Skin exam – wrists/waistline',
      'Skin exam – signs of secondary infection'
    ],
    investigations: [
      CaseItem('Skin scraping microscopy',
          'Mites, eggs, and fecal pellets seen — confirms the diagnosis.'),
      CaseItem('CBC (Complete Blood Count)',
          'Mild eosinophilia, otherwise unremarkable.'),
      CaseItem('Wound swab/culture (infected lesions)',
          'Staphylococcus aureus isolated.'),
    ],
    idealIx: ['Skin scraping microscopy'],
    idealDiagnosis: 'Scabies with secondary bacterial infection',
    idealManagement:
        'Topical permethrin 5% cream applied to the whole body, left on overnight and repeated after one week; treat secondary infection with appropriate antibiotics if significant; antihistamines for itching; wash all clothing and bedding in hot water; treat close contacts/household members simultaneously to prevent reinfection; hygiene counseling.',
  ),
  const CaseModel(
    id: 'panic_disorder',
    specialty: 'Psychiatry',
    title: 'Sudden episodes of palpitations and fear',
    teaser:
        'A young teacher describes recurring episodes of a racing heart and overwhelming fear over the last month.',
    patientName: 'Sara Ahmed',
    patientAge: 25,
    patientGender: 'Female',
    patientOccupation: 'Teacher',
    informant: null,
    vitals: {
      'HR': '82 bpm',
      'BP': '118/76 mmHg',
      'Temp': '37.0°C',
      'RR': '16/min',
      'SpO2': '99%'
    },
    opening:
        'Doctor sahab, mujhe achanak dil bohat zor se dhak dhak karne lagta hai, saans phool jati hai, lagta hai main mar jaaon gi... pichlay mahine se aisa kai baar ho chuka hai.',
    facts:
        '\n- Sudden episodes of intense fear, palpitations, shortness of breath, sweating, and trembling, lasting about 10-20 minutes each.\n- About 5-6 such episodes over the last month, unpredictable, sometimes even at rest or while trying to sleep.\n- Between episodes, feels anxious about when the next one will happen; has started avoiding crowded places and going out alone.\n- Already had an ECG and cardiac check-up during one episode at an emergency room — was told her heart was fine.\n- No chest pain radiating anywhere, no loss of consciousness during the episodes.\n- Sleep has been disturbed, appetite reduced somewhat, feels tired during the day.\n- No history of substance use, no notably high caffeine intake.\n- Some stress at work and personal life recently but no single major trigger she can identify.\n- No prior psychiatric history; no known family history of mental illness.\n- Hesitant to talk about it at first, worried people will think she is "paagal" (crazy) for seeing a psychiatrist.\n- If asked something not covered here, answer vaguely and plausibly, never contradict the facts above, never mention a diagnosis.',
    exam: [
      CaseItem('General inspection / mental state exam',
          'Appears anxious and fidgety, but oriented and coherent, with no evidence of hallucinations or delusions.'),
      CaseItem('Vitals recheck',
          'Currently normal: HR 82 bpm, BP 118/76 mmHg, Temp 37.0°C, RR 16/min — she is not in an active episode right now.'),
      CaseItem(
          'Cardiovascular examination', 'Normal heart sounds, no murmurs.'),
      CaseItem('Respiratory examination', 'Chest clear, normal breath sounds.'),
      CaseItem('Thyroid examination', 'No goiter, no signs of thyrotoxicosis.'),
      CaseItem(
          'Neurological examination', 'Grossly normal, no focal deficits.'),
    ],
    idealExam: [
      'General inspection / mental state exam',
      'Vitals recheck',
      'Thyroid examination'
    ],
    investigations: [
      CaseItem('ECG', 'Normal sinus rhythm, no ischemic changes.'),
      CaseItem('Thyroid function tests (TSH, T3, T4)',
          'Within normal limits — rules out hyperthyroidism.'),
      CaseItem('CBC (Complete Blood Count)',
          'Normal — rules out anemia as a cause of palpitations.'),
      CaseItem('Random blood glucose', 'Normal — rules out hypoglycemia.'),
      CaseItem('Echocardiogram',
          'Not indicated given a reassuring ECG and clinical exam.'),
    ],
    idealIx: [
      'ECG',
      'Thyroid function tests (TSH, T3, T4)',
      'Random blood glucose'
    ],
    idealDiagnosis: 'Panic disorder (after excluding organic causes)',
    idealManagement:
        'Reassurance and psychoeducation about panic disorder, referral for Cognitive Behavioral Therapy (CBT), consider an SSRI (e.g. sertraline) if symptoms are significant or persistent, avoid long-term benzodiazepine use (short-term only for acute severe symptoms if needed), lifestyle measures (reduce caffeine, regular sleep and exercise), psychiatric referral, safety-net and follow-up.',
  ),
];
