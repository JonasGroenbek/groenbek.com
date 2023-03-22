import React from 'react';
import Image from 'next/image';
import MeImg from '../../public/assets/me.png';

export default () => {
  return (
    <div id='about' className='w-full md:h-screen flex items-center py-16'>
      <div className='max-w-[1240px] m-auto md:grid grid-cols-3 gap-8'>
        <div className='col-span-2'>
          <p className='uppercase text-xl tracking-widest text-[#5651e5]'>
            About
          </p>
          <h2 className='py-4'>Who I Am</h2>
          <p className='py-2 text-gray-600'>
          Living in Denmark and commuting to my back then Swedish high school, I spent around 2500 hours commuting. 
          While doing so, I often watched my classmate build an android application while on the train. 
          He would often try to explain concepts to me, or I would come up with ideas for the app. 
          After multiple failed attempts to build one myself, I chose to study Computer Science and, later, Software Development.
          </p>
          <p className='py-2 text-gray-600'>

          Since graduating with a Bachelor’s in Software Development, I have played a vital role in building various systems with influences across the stack.
          I am most effective in building web-based products, particularly in TypeScript, 
          where I am experienced in building client-side and server-side applications.
          I have worked with software development operations such as data migrations, 
          service monitoring, automated testing, CI/CD pipelines, system infrastructure, and automated deployment strategies.
          More recently, I have had some responsibilities within management, 
          where I have worked with business operations and managing other developers.
          </p>
        </div>
        <div className='w-full h-auto m-auto shadow-xl shadow-gray-400 rounded-xl flex items-center justify-center p-4 hover:scale-105 ease-in duration-300'>
          <Image src={MeImg} className='rounded-xl' alt='A picture of myself  ' />
        </div>
      </div>
    </div>
  );
};