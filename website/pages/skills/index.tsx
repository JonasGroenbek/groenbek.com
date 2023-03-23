import React from "react";
import ReactImg from "../../public/assets/react.png";
import GithubImg from "../../public/assets/github.png";
import NestjsImg from "../../public/assets/nestjs.png";
import TypescriptImg from "../../public/assets/typescript.png";
import CircleCiImg from "../../public/assets/circleci.png";
import AWSImg from "../../public/assets/aws.png";
import JestImg from "../../public/assets/jest.png";
import RedisImg from "../../public/assets/redis.png";
import PulumiImg from "../../public/assets/pulumi.png";
import PostgresImg from "../../public/assets/postgres.webp";
import DockerImg from "../../public/assets/docker.png";
import KubernetesImg from "../../public/assets/kubernetes.png";
import Skill from "./Skill";

export default function Skills() {
  return (
    <div id="skills" className="w-full lg:h-screen p-2">
      <div className="max-w-[1240px] mx-auto flex flex-col justify-center h-full">
        <p className="text-xl tracking-widest uppercase text-[#5651e5]">
          Skills
        </p>
        <p className="py-2 text-gray-600">
          I gravitate towards the intricacies of software development,
          especially when it comes to applying architectural designs and
          patterns. I have worked with many technologies; some usually make a
          more significant impression than others. Below is a list of some I am
          proficient with and would use for a future project.
        </p>
        <h2 className="py-4">Technologies</h2>
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-8">
          <Skill img={TypescriptImg} text="Typescript" />
          <Skill img={NestjsImg} text="NestJS" />
          <Skill img={ReactImg} text="React" />
          <Skill img={JestImg} text="Jest" />
          <Skill img={GithubImg} text="Github" />
          <Skill img={CircleCiImg} text="CircleCI" />
          <Skill img={RedisImg} text="Redis" />
          <Skill img={PostgresImg} text="PostgreSQL" />
          <Skill img={PulumiImg} text="Pulumi" />
          <Skill img={AWSImg} text="AWS" />
          <Skill img={DockerImg} text="Docker" />
          <Skill img={KubernetesImg} text="Kubernetes" />
        </div>
      </div>
    </div>
  );
}
