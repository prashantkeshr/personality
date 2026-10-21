# Google Play listing — Personality

Paste-ready text for Play Console. Limits: app name 30, short description 80, full description 4000 characters.

## App details

| Field | Value |
|---|---|
| App name | Personality: Wellness & Style |
| Package | com.dhurta.personality |
| Category | Health & Fitness (secondary feel: Lifestyle) |
| Tags | Wellness, Habit tracker, Fitness, Personal style |
| Developer | dhurta.Inc |
| Contact email | support@dhurta.org |
| Privacy policy URL | *the hosted copy of `docs/store/privacy-policy.html` (see RELEASE_CHECKLIST.md)* |
| Price | Free, no ads, no in-app purchases |

## Short description (80)

Private wellness & style: posture, habits, fitness, face shape. All on-device.

## Full description

Personality is your private, all-in-one wellness and style companion. Track your health, build better habits, check your posture, find styles that suit your face and grow new skills — and everything stays on your phone.

PRIVATE BY DESIGN
• No account, no ads, no tracking, no cloud.
• Your data is stored in an encrypted database on your device.
• Camera analysis runs on your phone; frames are never uploaded.
• Optional app lock with a PIN, fingerprint or your phone's screen lock.

HEALTH & HABITS
• Water, meals, sleep, activity, steps and weight, with clear charts.
• Habits with ready-made ideas you can edit, and streaks that keep you going.
• Daily plan and routines with reminders — choose the sound, vibration and quiet hours.
• Body plan with calorie and protein targets, meal ideas and a sample day.
• Weight journey with goals and progress.

CAMERA CHECKS (ON-DEVICE)
• Posture check with clear, neutral feedback and stretches that help.
• Exercise tracking that counts reps and holds.
• Face shape with balance and proportions — for interest, never a score.

STYLE
• 31 hairstyles, beards and glasses matched to your face shape.
• Live try-on for hair, glasses, beards, lip and blush shades.
• Makeup guide by face shape and skin undertone.
• Colour analysis, Style DNA, wardrobe, outfit calendar and a personal lookbook.
• Style trends and an offline style Q&A.

AI COACH (OFFLINE)
• Ask about fitness, food, sleep, posture, skin, hair or style.
• Answers come from the app's own guides and your data, with pictures and links to the right screen.
• Optional small on-device model (about 430 MB, one-time download); your questions never leave your phone.

MY GROWTH
• Yoga, self-defence, boxing, karate, kung fu and Indian martial arts, with animated guides and safety notes (solo practice only).
• Add a practice to your day with a reminder.
• About Your Personality: one page with your ratings by area, key things to improve and exercises suggested for you.

HOME-SCREEN WIDGETS
• Today, My growth, Exercise, Weight, Water, Sleep, Your focus and Habits — with charts and one-tap actions.

Available in English, हिन्दी, Español, Português, Bahasa Indonesia and العربية.

Personality offers general wellness and style guidance. It is not a medical device and does not diagnose or treat any condition.

## What's new (first release)

First release: health and habit tracking, on-device posture and face checks, style try-on, martial arts and yoga guides, home-screen widgets and six languages.

## Hindi listing (optional, add as a translation)

**Short:** निजी वेलनेस और स्टाइल साथी: पोस्चर, आदतें, फ़िटनेस, चेहरे का आकार। सब फ़ोन पर।

**Full (opening):** Personality आपका निजी वेलनेस और स्टाइल साथी है। सेहत ट्रैक करें, अच्छी आदतें बनाएँ, पोस्चर जाँचें, अपने चेहरे पर जँचने वाले स्टाइल खोजें और नई कलाएँ सीखें — और सब कुछ आपके फ़ोन पर ही रहता है। कोई अकाउंट नहीं, कोई विज्ञापन नहीं, कोई ट्रैकिंग नहीं।

---

# Play Console forms

## Data safety

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **No.** All data is processed and stored only on the device; nothing is transmitted off the device. (Google's definition of "collect" means transmitted off the device.) |
| Is all user data encrypted in transit? | Not applicable — no user data is transmitted. Pack downloads use HTTPS. |
| Do you provide a way for users to request deletion? | Users can delete records in the app; uninstalling deletes all data. |

Notes for review: content-pack downloads send only a standard HTTPS file request to raw.githubusercontent.com, and the optional AI-coach model is a one-time HTTPS download from huggingface.co (no identifiers in either). The coach runs on-device; prompts are never transmitted. ML Kit runs on-device and its datatransport uploader is removed in the manifest.

## Content rating (IARC questionnaire)

- Category: **Reference, News, or Educational / Health & Fitness utility**.
- Violence: **No** (martial-arts guides are solo technique demonstrations with safety notes, no combat or injury depiction).
- Sexual content, profanity, drugs, gambling: **No**.
- User interaction / user-generated content shared with others: **No**.
- Shares location: **No**. Digital purchases: **No**.
- Expected rating: Everyone / PEGI 3 (wellness content). Set **target audience 13+** (or 16+) because of weight and body tracking.

## Target audience and content

- Target age groups: **13–15, 16–17, 18+** (not designed for children; no child-directed content).
- Appeals to children: **No**.
- Ads: **No ads**.

## Sensitive permissions — declarations

| Permission | Why (text for the declaration) |
|---|---|
| CAMERA | On-device posture checks, exercise rep counting, face-shape analysis and live style try-on. Frames are processed in memory and never stored or uploaded unless the user saves a photo. |
| ACTIVITY_RECOGNITION | Counts steps and active minutes from the phone's own sensors for the activity tracker. |
| Health Connect: READ_STEPS, READ_DISTANCE, READ_EXERCISE, READ_SLEEP, READ_WEIGHT, READ_HEIGHT, READ_HYDRATION | Optional import so users see their existing health data in one private dashboard. Read-only; data stays on the device; never used for ads. Declare in the **Health apps declaration** and complete the Health Connect permissions form (link the privacy policy; the in-app rationale screen is `ACTION_SHOW_PERMISSIONS_RATIONALE`). |
| POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, VIBRATE | Local reminders the user schedules, restored after a restart. |
| INTERNET, ACCESS_NETWORK_STATE | Only for downloading optional content packs and the optional on-device AI model when the user taps Download (and respecting "Wi-Fi only"). |

## Health apps declaration

- App features: fitness/activity tracking, nutrition and hydration tracking, sleep tracking, weight management, mental wellness habits.
- Not a medical device; no diagnosis or treatment claims.
