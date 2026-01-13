import { Settings } from "lucide-react";
import { useState } from "react";
import { TabBar, Tab } from "./components/TabBar";
import { RecentTab } from "./components/RecentTab";
import { MyNotesTab } from "./components/MyNotesTab";
import { SettingsTab } from "./components/SettingsTab";
import { DraftDetailPage } from "./components/DraftDetailPage";
import { NoteDetailPage } from "./components/NoteDetailPage";
import { AIConfigPage } from "./components/AIConfigPage";
import { NotificationSettingsPage } from "./components/NotificationSettingsPage";
import { DataManagementPage } from "./components/DataManagementPage";
import { AboutPage } from "./components/AboutPage";
import { Toast } from "./components/Toast";

const initialUncategorizedNotes = [
  { id: "unc-1", title: "随手记录 - 项目想法", icon: "📝" },
  { id: "unc-2", title: "临时笔记 - 会议记录", icon: "📝" },
  { id: "unc-3", title: "待整理 - 学习资料", icon: "📝" },
  { id: "unc-4", title: "灵感备忘录", icon: "💡" },
];

const initialDraftNotes = [
  {
    id: "4",
    title: "UX Workshop Notes",
    summary:
      "Brainstorming session on improving user onboarding experience",
    timestamp: "Yesterday",
    videoUrl: "https://example.com/video/ux-workshop",
  },
  {
    id: "5",
    title: "Marketing Strategy Call",
    summary:
      "Q1 campaign planning and budget allocation discussion",
    timestamp: "Jan 7",
    videoUrl: "https://example.com/video/marketing-call",
  },
  {
    id: "6",
    title: "Engineering Sync",
    summary:
      "Technical architecture review and performance optimization",
    timestamp: "Jan 6",
    videoUrl: "https://example.com/video/engineering-sync",
  },
];

const initialPersonalLibrary = [
  {
    id: "1",
    title: "Interview",
    icon: "📁",
    type: "folder" as const,
    children: [
      {
        id: "1-1",
        title: "Technical Interview Notes",
        icon: "📄",
      },
      { id: "1-2", title: "Behavioral Questions", icon: "📄" },
      { id: "1-3", title: "Company Research", icon: "📄" },
    ],
  },
  {
    id: "2",
    title: "TERM 2",
    icon: "📁",
    type: "folder" as const,
    children: [
      { id: "2-1", title: "Lecture Notes", icon: "📄" },
      { id: "2-2", title: "Assignment Ideas", icon: "📄" },
    ],
  },
  {
    id: "3",
    title: "enhancement",
    icon: "📄",
    type: "folder" as const,
    children: [
      { id: "3-1", title: "UI Improvements", icon: "📄" },
      { id: "3-2", title: "Feature Requests", icon: "📄" },
    ],
  },
  {
    id: "4",
    title: "term1",
    icon: "📄",
    type: "folder" as const,
    children: [
      { id: "4-1", title: "Week 1 Notes", icon: "📄" },
      { id: "4-2", title: "Final Project", icon: "📄" },
    ],
  },
  {
    id: "5",
    title: "常用 prompt 库",
    icon: "💥",
    type: "folder" as const,
    children: [
      { id: "5-1", title: "Writing Prompts", icon: "📄" },
      { id: "5-2", title: "Code Generation", icon: "📄" },
    ],
  },
  {
    id: "6",
    title: "从电脑桌面开始吧！",
    icon: "📄",
    type: "folder" as const,
    children: [
      { id: "6-1", title: "Desktop Setup", icon: "📄" },
      { id: "6-2", title: "Workflow Tips", icon: "📄" },
    ],
  },
  {
    id: "7",
    title: "Student Job Application Tracker",
    icon: "🎯",
    type: "folder" as const,
    children: [
      { id: "7-1", title: "Applications Sent", icon: "📄" },
      { id: "7-2", title: "Follow-ups", icon: "📄" },
    ],
  },
  {
    id: "8",
    title: "Classroom Home",
    icon: "🏠",
    type: "folder" as const,
    children: [
      { id: "8-1", title: "Class Schedule", icon: "📄" },
      { id: "8-2", title: "Attendance", icon: "📄" },
    ],
  },
  {
    id: "9",
    title: "Student Planner",
    icon: "📅",
    type: "folder" as const,
    children: [
      { id: "9-1", title: "Weekly Tasks", icon: "📄" },
      { id: "9-2", title: "Deadlines", icon: "📄" },
    ],
  },
  {
    id: "10",
    title: "Lesson Plans",
    icon: "🔖",
    type: "folder" as const,
    children: [
      { id: "10-1", title: "Week 1 Plan", icon: "📄" },
      { id: "10-2", title: "Week 2 Plan", icon: "📄" },
    ],
  },
  {
    id: "11",
    title: "神经网络学习",
    icon: "🧠",
    type: "folder" as const,
    children: [
      { id: "11-1", title: "yolo模型与cnn", icon: "📄" },
    ],
  },
];

export default function App() {
  const [activeTab, setActiveTab] = useState<Tab>("recent");
  const [uncategorizedNotes, setUncategorizedNotes] = useState(
    initialUncategorizedNotes,
  );
  const [categorySheetNoteId, setCategorySheetNoteId] =
    useState<string | null>(null);
  const [personalLibrary, setPersonalLibrary] = useState(
    initialPersonalLibrary,
  );
  const [draftNotes, setDraftNotes] = useState(
    initialDraftNotes,
  );
  const [selectedDraft, setSelectedDraft] = useState<
    (typeof initialDraftNotes)[0] | null
  >(null);
  const [selectedNote, setSelectedNote] = useState<{
    id: string;
    title: string;
    icon: string;
  } | null>(null);
  const [showToast, setShowToast] = useState(false);
  const [toastMessage, setToastMessage] = useState("");
  const [showAIConfig, setShowAIConfig] = useState(false);
  const [
    showNotificationSettings,
    setShowNotificationSettings,
  ] = useState(false);
  const [showDataManagement, setShowDataManagement] =
    useState(false);
  const [showAbout, setShowAbout] = useState(false);

  const handleNoteClick = (noteId: string) => {
    // Switch to notes tab and open category sheet
    setActiveTab("notes");
    setCategorySheetNoteId(noteId);
  };

  const handleDraftClick = (draftId: string) => {
    const draft = draftNotes.find((d) => d.id === draftId);
    if (draft) {
      setSelectedDraft(draft);
    }
  };

  const handleDraftBack = () => {
    setSelectedDraft(null);
  };

  const handleDraftDelete = (draftId: string) => {
    setDraftNotes(draftNotes.filter((d) => d.id !== draftId));
    setSelectedDraft(null);
    setToastMessage("草稿已删除");
    setShowToast(true);
  };

  const handleDraftRetry = (draftId: string) => {
    // Simulate retry action
    setToastMessage("正在重新记录...");
    setShowToast(true);
    setSelectedDraft(null);
  };

  const handleLibraryNoteClick = (noteId: string) => {
    // Find the note in personal library
    let foundNote = null;
    for (const folder of personalLibrary) {
      if (folder.children) {
        const note = folder.children.find(
          (n) => n.id === noteId,
        );
        if (note) {
          foundNote = note;
          break;
        }
      }
    }
    if (foundNote) {
      setSelectedNote(foundNote);
    }
  };

  const handleNoteBack = () => {
    setSelectedNote(null);
  };

  const handleNoteSave = (
    noteId: string,
    updatedContent: { title: string; content: string },
  ) => {
    // Update the note in personal library
    setPersonalLibrary(
      personalLibrary.map((folder) => {
        if (folder.children) {
          return {
            ...folder,
            children: folder.children.map((note) =>
              note.id === noteId
                ? { ...note, title: updatedContent.title }
                : note,
            ),
          };
        }
        return folder;
      }),
    );

    // Update selected note
    if (selectedNote && selectedNote.id === noteId) {
      setSelectedNote({
        ...selectedNote,
        title: updatedContent.title,
      });
    }

    setToastMessage("笔记已保存");
    setShowToast(true);
  };

  const handleSettingsItemClick = (itemId: string) => {
    if (itemId === "1") {
      // AI Config
      setShowAIConfig(true);
    } else if (itemId === "2") {
      // Notification Settings
      setShowNotificationSettings(true);
    } else if (itemId === "3") {
      // Data Management
      setShowDataManagement(true);
    } else if (itemId === "4") {
      // About
      setShowAbout(true);
    }
  };

  const handleAIConfigBack = () => {
    setShowAIConfig(false);
  };

  const handleNotificationSettingsBack = () => {
    setShowNotificationSettings(false);
  };

  const handleDataManagementBack = () => {
    setShowDataManagement(false);
  };

  const handleAboutBack = () => {
    setShowAbout(false);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#87CEEB] to-[#000000] pb-24 relative overflow-hidden">
      {/* Decorative background elements */}
      <div className="absolute top-0 left-0 w-96 h-96 bg-[#5DADE2] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob"></div>
      <div className="absolute top-0 right-0 w-96 h-96 bg-[#3498DB] rounded-full mix-blend-multiply filter blur-3xl opacity-50 animate-blob animation-delay-2000"></div>
      <div className="absolute bottom-0 left-1/2 w-96 h-96 bg-[#1C1C1C] rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000"></div>

      {/* Draft Detail Page - overlay on top */}
      {selectedDraft && (
        <DraftDetailPage
          note={selectedDraft}
          onBack={handleDraftBack}
          onDelete={handleDraftDelete}
          onRetry={handleDraftRetry}
        />
      )}

      {/* Note Detail Page */}
      {selectedNote && (
        <NoteDetailPage
          note={selectedNote}
          onBack={handleNoteBack}
          onSave={handleNoteSave}
        />
      )}

      {/* AI Config Page */}
      {showAIConfig && (
        <AIConfigPage onBack={handleAIConfigBack} />
      )}

      {/* Notification Settings Page */}
      {showNotificationSettings && (
        <NotificationSettingsPage
          onBack={handleNotificationSettingsBack}
        />
      )}

      {/* Data Management Page */}
      {showDataManagement && (
        <DataManagementPage onBack={handleDataManagementBack} />
      )}

      {/* About Page */}
      {showAbout && <AboutPage onBack={handleAboutBack} />}

      {/* Header */}
      <header className="relative px-5 pt-16 pb-4">
        <div className="flex items-center justify-between">
          <h1 className="text-[64px] font-bold tracking-tight text-white font-[Aclonica] drop-shadow-lg">
            Notey
          </h1>
        </div>
      </header>

      {/* Content - render based on active tab */}
      {activeTab === "recent" && (
        <RecentTab
          uncategorizedNotes={uncategorizedNotes}
          onNoteClick={handleNoteClick}
          draftNotes={draftNotes}
          onDraftClick={handleDraftClick}
        />
      )}
      {activeTab === "notes" && (
        <MyNotesTab
          uncategorizedNotes={uncategorizedNotes}
          setUncategorizedNotes={setUncategorizedNotes}
          categorySheetNoteId={categorySheetNoteId}
          setCategorySheetNoteId={setCategorySheetNoteId}
          personalLibrary={personalLibrary}
          setPersonalLibrary={setPersonalLibrary}
          onLibraryNoteClick={handleLibraryNoteClick}
        />
      )}
      {activeTab === "settings" && (
        <SettingsTab
          onSettingsItemClick={handleSettingsItemClick}
        />
      )}

      {/* Bottom Tab Bar */}
      <TabBar
        activeTab={activeTab}
        onTabChange={setActiveTab}
      />

      {/* Toast notification */}
      <Toast
        message={toastMessage}
        isVisible={showToast}
        onClose={() => setShowToast(false)}
      />
    </div>
  );
}