import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "MetalPop - Global Metal Band Distribution",
  description: "Interactive map showing metal band distribution and density across the world",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
