# Flashcard Generator

## 📌 Overview
The **Flashcard Generator** is an AI-powered tool that automates the creation of flashcards from PDFs. It extracts key information, generates structured flashcards, and stores them in a Supabase database, making studying more efficient and interactive.

## 🚀 Features
- 📄 **Extracts key information** from uploaded PDF files
- 🤖 **Uses AI models (T5, BERT, BART)** for flashcard generation
- 📦 **Stores generated flashcards in Supabase**
- 🌐 **Firebase & Supabase integration** for seamless data management
- 📱 **Flutter-based front-end** for an intuitive user experience

## 🛠️ Tech Stack
- **Frontend:** Flutter
- **Backend:** Google Colab (for AI processing)
- **Database:** Supabase
- **Storage:** Firebase & Supabase
- **AI Models:** T5, BERT, BART

## 🔧 Backend Setup (Google Colab)
The backend for this project runs separately on **Google Colab**, where AI models process PDFs and generate flashcards. The processed flashcards are then stored in **Supabase**.

### **How the Backend Works**
- The **Flutter app** sends PDF files to the **Google Colab backend**.
- AI processes the document and generates structured flashcards.
- The processed flashcards are then stored in **Supabase** for easy retrieval.

## 📂 Project Structure
```
flashcard-generator/
│── lib/                # Flutter app source code
│── assets/             # App assets
│── .env                # Environment variables (not tracked in Git)
│── pubspec.yaml        # Flutter dependencies
│── README.md           # Project documentation
```

## 🔧 Setup & Installation
### **1️⃣ Clone the repository**
```sh
git clone https://github.com/yourusername/flashcard-generator.git
cd flashcard-generator
```

### **2️⃣ Install dependencies**
```sh
flutter pub get
```

### **3️⃣ Set up environment variables**
Create a `.env` file in the root directory and add:
```
SUPABASE_URL="https://your-supabase-url.supabase.co"
SUPABASE_ANON_KEY="your-anon-key"
```

### **4️⃣ Run the app**
```sh
flutter run
```

## 📝 Usage
1. Upload a PDF file.
2. AI processes the document and generates flashcards.
3. Flashcards are saved in Supabase.
4. Review, edit, and study your flashcards within the app.

## 🤝 Contributing
Contributions are welcome! Feel free to fork the repo, make improvements, and submit a pull request.

## 🛡️ Security
- **DO NOT** commit your `.env` file to GitHub.
- Always use environment variables to store API keys securely.


---
🚀 **Happy Learning!**

