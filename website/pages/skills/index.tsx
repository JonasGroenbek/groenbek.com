import React from 'react';
import CssImg from '../../public/assets/css.png';
import ReactImg from '../../public/assets/react.png';
import GithubImg from '../../public/assets/github.png';
import NestjsImg from '../../public/assets/nestjs.png'
import TypescriptImg from '../../public/assets/typescript.png'
import CircleCiImg from '../../public/assets/circleci.png'
import AWSImg from '../../public/assets/aws.png';
import JestImg from '../../public/assets/jest.png';
import RedisImg from '../../public/assets/redis.png';
import PulumiImg from '../../public/assets/pulumi.png';
import PostgresImg from '../../public/assets/pulumi.png';
import Skill from './Skill'

const Skills = () => {
  return (
    <div id='skills' className='w-full lg:h-screen p-2'>
      <div className='max-w-[1240px] mx-auto flex flex-col justify-center h-full'>
        <p className='text-xl tracking-widest uppercase text-[#5651e5]'>
          Skills
        </p>
        <h2 className='py-4'>What I Can Do</h2>
        <div className='grid grid-cols-2 lg:grid-cols-4 gap-8'>
            <Skill img={CssImg} text="CSS"/>
            <Skill img={ReactImg} text="React"/>
            <Skill img={GithubImg} text="Github"/>
            <Skill img={TypescriptImg} text="Typescript"/>
            <Skill img={NestjsImg} text="NestJS"/>
            <Skill img={CircleCiImg} text="CircleCI"/>
            <Skill img={AWSImg} text="AWS"/>
            <Skill img={RedisImg} text="Redis"/>
            <Skill img={JestImg} text="Jest"/>
            <Skill img={PulumiImg} text="Pulumi"/>
            <Skill img={PostgresImg} text="PostgreSQL"/>
        </div>
      </div>
    </div>
  );
};

export default Skills;
