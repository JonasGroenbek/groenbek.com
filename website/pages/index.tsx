import React from "react";
import Head from "next/head";
import About from "./about";
import Contact from "./contact";
import Skills from "./skills";
import { FaGithub, FaLinkedinIn } from "react-icons/fa";
import Link from "next/link";
import { AiOutlineMail } from "react-icons/ai";

export default function Home() {
  return (
    <div>
      <Head>
        <title>Jonas Grønbek</title>
        <meta
          name="description"
          content="Building maintainable and robust software applications, with an eye for patterns and architectural design."
        />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div id="home" className="w-full h-screen text-center">
        <div className="max-w-[1240px] w-full h-full mx-auto flex justify-center items-center">
          <div>
            <h1 className="py-4 text-gray-700">
              Hi, I&#39;m <span className="text-[#5651e5]"> Jonas</span>
            </h1>
            <h1 className="py-2 text-gray-700">A Software Developer</h1>
            <p className="py-4 text-gray-600 sm:max-w-[70%] m-auto">
              Building maintainable and robust software applications, with an
              eye for patterns and architectural design.
            </p>
            <div className="flex items-center justify-between max-w-[330px] m-auto py-4">
              <a
                href="https://www.linkedin.com/in/jonas-groenbek/"
                target="_blank"
                rel="noreferrer"
              >
                <div className="rounded-full shadow-lg shadow-gray-400 p-6 cursor-pointer hover:scale-110 ease-in duration-300">
                  <FaLinkedinIn />
                </div>
              </a>
              <a
                href="https://github.com/jonasgroenbek"
                target="_blank"
                rel="noreferrer"
              >
                <div className="rounded-full shadow-lg shadow-gray-400 p-6 cursor-pointer hover:scale-110 ease-in duration-300">
                  <FaGithub />
                </div>
              </a>
              <Link href="/#contact">
                <div className="rounded-full shadow-lg shadow-gray-400 p-6 cursor-pointer hover:scale-110 ease-in duration-300">
                  <AiOutlineMail />
                </div>
              </Link>
            </div>
          </div>
        </div>
      </div>
      <About />
      <Skills />
      <Contact />
    </div>
  );
}
