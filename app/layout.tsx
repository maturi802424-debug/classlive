import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "ClassLive",
  description: "一人ひとりの参加が、教室を動かす。",
  other: {
    "codex-preview": "development",
  },
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body className="antialiased">{children}</body>
    </html>
  );
}
