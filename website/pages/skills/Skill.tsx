import React from "react";
import Image, { StaticImageData } from "next/image";

const SIZE_PX = 70;

interface Props {
  img: StaticImageData;
  text: string;
}

export default function Skill({ img, text }: Props) {
  return (
    <div className="p-6 shadow-xl rounded-xl hover:scale-105 ease-in duration-300">
      <div className="grid grid-cols-2 gap-4 justify-center items-center">
        <div className="m-auto">
          <Image
            className="object-cover"
            width={SIZE_PX}
            height={SIZE_PX}
            src={img}
            alt="/"
          />
        </div>
        <div className="flex flex-col items-center justify-center">
          <h3>{text}</h3>
        </div>
      </div>
    </div>
  );
}
