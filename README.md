
````markdown
# 📦 iSUPPLY Order Tracker App (Flutter + Firebase)

This is a Flutter-based order tracking system built for **iSUPPLY B2B pharmacy**. It allows users to track their orders through push notifications and a dynamic visual timeline.

---

## 🎯 Features

✅ Real-time **push notifications** using Firebase Cloud Messaging (FCM)  
✅ Works in all app states: Foreground, Background, and Terminated  
✅ Visual **progress timeline** with status updates  
✅ Firestore-backed order updates  
✅ Local notifications for instant feedback  
✅ Supports reset & cancel actions for demo purposes  
✅ MVVM architecture with clean code separation  
✅ Branded UI with iSUPPLY style

---

## 🚀 Tech Stack

- **Flutter**
- **Firebase** (Messaging, Firestore)
- **Provider** (State management)
- **Flutter Local Notifications**
- **Google Fonts**
- **Clean Architecture (MVVM)**

---

## 📱 Screenshots


---

## 🔧 How to Run

1. **Clone the repo**
   ```bash
   git clone https://github.com/ranaehelal/i_supply_order_tracker.git
   cd isupply-order-tracker
````

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Add Firebase Config**

   * Add `google-services.json` to `android/app/`
   * Add your Firebase Admin SDK key to:

     ```
     lib/keys/isupplyordertracker-firebase-adminsdk-fbsvc-7c5684ea3f.json
     ```

4. **Run the app**

   ```bash
   flutter run
   ```

---

## 📦 Order Flow

* `Pending` → `Confirmed` → `Shipped` → `Delivered`
* Each transition triggers:

  * Push Notification (FCM)
  * UI timeline update
  * Firestore status update

> ❌ Order can be **cancelled** anytime before delivery
> 🔁 Order can be **reset** from the UI after final state for demo

---

## 🔔 Notification Behavior

| App State  | Notification Type              |
| ---------- | ------------------------------ |
| Foreground | Local notification + UI update |
| Background | System push notification + UI update |
| Terminated | System push notification       |

---

## 📽️ Demo Video

Watch the full demo here:
👉 [Video Link](https://drive.google.com/file/d/15UWREIddMlBwz1a3i6J3aob_NfvIduJ0/view?usp=sharing)


## 👩‍💻 Developed by

**Rana Helal**
Flutter Developer & AI Enthusiast
📍 Cairo, Egypt

---

## 🛡️ License

This project is for demo and assessment purposes only. All rights reserved to the iSUPPLY Team.

```
