import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata = {
  title: "Unimed Suporte",
  description: "Unimed app",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <Head>
        <link rel="preload" as="image" href="/public/unimed.jpg" />
      </Head>
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased bg-cover bg-center`}
        style={{ 
          backgroundImage: "url('/public/unimed.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      >
        {children}
      </body>
    </html>
  );
}
