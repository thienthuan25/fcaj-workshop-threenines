---
title: "Event 4"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 4.4. </b> "
---

# Reflection Report on "FCAJ Community Day"

- Time: 9:00 AM - 12:00 AM, June 27, 2026.
- 26th Floor, Bitexco Financial Tower, No. 2 Hai Trieu Street, Ben Nghe Ward, District 1, Ho Chi Minh City, Vietnam.

### Purpose of the Event

The FCAJ Community Day event on June 27, 2026, was organized with the main purpose of creating a space for connection and sharing in-depth knowledge about cloud technology and artificial intelligence. The program aimed to provide practical perspectives on modern applications such as Voice AI, automation systems in operations, and AI solutions in human resource management. Through presentations from experienced speakers, the event sought to inspire and equip the community with the necessary skills to solve specific business problems, while promoting innovative thinking in applying technology to business practice.

### Participation Role

At this event, I participated as an attendee, listening to and gaining practical knowledge from leading experts in the industry, thereby keeping up with the latest technology trends.

### List of Speakers

- **Steve Trần** - CTO at CloudThinker
- **Trung Vũ** - Founder of Revve AI
- **Kiệt Trần** - AI Engineer at Revve AI
- **Danh Hoàng Hiếu Nghị** - AI Engineer at Renova Cloud
- **Phan Kim Bảo** - Cloud Engineer
- **Nguyên Nguyễn** - Cloud Engineer at Cloud Kinetics Vietnam
- **Trường Trần** - Solutions Sales at Noventiq Vietnam
- **Minh Anh** - Solutions Sales at Noventiq Vietnam
- **Nguyễn Đức Toàn** - Technical Cloud Engineer at Keyloop

### Content 

The event was an in-depth sharing session on cloud technology and artificial intelligence, focusing on practical solutions for enterprises.

#### Topic 1: Deep Response Engine: From Detection to Autonomous Resolution - Steve Trần

- Solving the complexity problem: As enterprises undergo digital transformation and systems become larger, complexity increases significantly. The use of multiple observability tools often leads businesses to hire more personnel for operations, further increasing complexity. Steve emphasized the role of AI in supporting senior engineers in operating infrastructure rather than completely replacing people.

- Multi-Agent architecture should be used instead of Single-Agent architecture in practical AI systems:

    + Optimize model selection for specialized tasks.
    + Avoid context dilution when putting all data into a single agent.
    + Support role and access control management.

- Product development mindset:

    + Execution: The important thing is to start doing immediately instead of spending too much time thinking.
    + Customer Champion: It is necessary to choose the right pioneering customers to work with directly, thereby validating technology ideas against real business problems.
    + Process transformation: To successfully deploy an AI system, enterprises often need to change more than 50% of their existing operational processes to fit the new capabilities of the system.

#### Topic 2: Voice Agents: Building Human-Like AI Conversations at Scale - Trung Vũ, Kiệt Trần, Danh Hoàng Hiếu Nghị

This topic shared the architecture and practical challenges of deploying AI voice systems in Vietnam.

- System architecture:

    + Analyzed two common architectures: **Speech-to-Speech** and the three-stage model: **Speech-to-Text** -> **LLM** -> **Text-to-Speech**.
    + For the Vietnamese market, the three-stage model is preferred because of its feasibility and better content control for a low-resource language such as Vietnamese.

- Practical challenges in enterprises:

    + Quality control: Enterprises need to ensure that AI does not provide inaccurate answers. Converting content to text makes management easier.
    + AI should not stop at answering questions but also needs the ability to execute tasks, such as locking cards and checking information, through calling external tools.
    + Human-in-the-loop: The system needs to be designed to hand over to human employees when AI encounters complex situations or when customers have a negative attitude.

#### Topic 3: AWS DevOps Agent: Your Always-Available Operations Teammate - Phan Kim Bảo & Nguyên Nguyễn

This topic discussed the **AWS DevOps Agent**, a tool that supports engineers in operating and handling system incidents.

- The role of DevOps Agent: The system operates as a teammate supporting operations engineers rather than replacing people. The Agent helps automate incident investigation, root cause analysis, and solution recommendations.

- The main pillars of DevOps Agent:

    + Context Learning: Uses Agent Space, a logical container, to understand the system structure through accessing resources and configurations and generating topology diagrams.
    + Integration: The ability to expand through MCP (Model Context Protocol) or integration with other services to query logs or data from external systems.
    + Collaboration: Supports interaction through multiple platforms such as Slack or ServiceNow.
    + Convenient: A simple setup process directly on the AWS Console.
    + Cost Effective: Costs are calculated based on runtime instead of infrastructure or token quantity.

- Practical experience:

    + Reducing incident resolution time (MTTR): For example, at an online university, DevOps Agent helped reduce issue resolution time from 2 hours to 28 minutes, which is 77% faster.
    + Root cause investigation: Supports identifying misconfigurations in complex systems, helping engineers save a significant amount of manual operation time.

DevOps Agent is a tool that amplifies engineers' skills. It works most effectively for organizations with clear infrastructure governance processes, transparent system history, and well-structured services.

#### Topic 5: AI-Powered Productivity: Workforce Planning For Enterprise - Trường Trần & Minh Anh

This topic discussed how to apply AI, especially **Amazon Quick**, to solve challenges in human resource management and optimize enterprise processes.

- Current challenges in recruitment: Enterprises often face issues such as spending too much time on manual CV screening, from one to two months, high dropout rates, and the lack of an accurate data framework to evaluate personnel, leading to inefficient recruitment.

- AI solutions: Using AI helps HR move from manual tasks to building human resource strategies and evaluating candidates based on standardized frameworks instead of subjective judgment. This helps enterprises save costs and time and increase their competitive value.

- The role of **Amazon Quick** in enterprises:

    + Agent customization: Users can create specialized AI Agents, for example, an HR Talent Review Assistant, to understand policies, read CVs, or analyze job descriptions.
    + Connectivity: Amazon Quick can connect to various data sources such as SharePoint, Outlook, Google Drive, Jira, and Salesforce through MCP (Model Context Protocol), allowing data extraction and processing directly without switching across many platforms.
    + Task automation: Amazon Quick not only answers questions but also performs tasks such as automatic CV screening with high-accuracy OCR, comparing candidates with job descriptions, recommending salaries, and generating recruitment reports.

- With the widespread use of AI in the screening process, candidates should focus on optimizing their CVs so that keywords match job descriptions in order to pass the automated screening round.

#### Topic 6: Building Secure Private MCP Connection with Amazon Quickuick - Nguyễn Đức Toàn & Danh Hoàng Hiếu Nghị

This topic explored the technical solution for securely connecting **Amazon Quick** with third-party data sources through MCP (Model Context Protocol) in enterprise environments.

- When connecting **Amazon Quick** with an **MCP Server** through the public Internet, enterprises face many risks such as DDoS attacks, data eavesdropping through Man-in-the-middle attacks, and violations of internal security policies.

- Private connection solution:

    + **VPC Connection**: Place Amazon Q inside a VPC (Virtual Private Cloud) environment to establish an internal connection.
    + **Interface Endpoint**: Set up VPC Endpoints and Private DNS so that requests to the MCP Server never pass through the public Internet.
    + **Technical structure**: Use an Application Load Balancer (ALB) combined with AWS Certificate Manager (ACM) for TLS encryption.

- Optimization and cost management:

    + Deploying a private security environment comes with additional infrastructure costs such as Route 53 Resolver, ALB, and EC2 operating costs for the MCP Server, estimated at approximately 250 to 350 USD per month for infrastructure components.
    + The speakers emphasized that although setting up a private connection has higher costs, it is a core factor in ensuring security compliance for large enterprises.

- Amazon Quick can connect with almost any third-party service, such as Zalo, WhatsApp, Jira, or internal storage systems, as long as those systems provide APIs, helping turn Amazon Q into a central assistant capable of securely accessing real-time data.

### What I Learned

After participating in the event, I learned a great deal and gained practical and in-depth perspectives on AI applications in enterprises:

**1.** Execution mindset in the AI era: Instead of spending too much time on theory, enterprises need to focus on execution through POC or MVP models. Choosing the right Customer Champion to solve practical problems is a vital factor for startup projects.

**2.** The importance of flexible architecture:

- **Multi-Agent Architecture**: Using multiple specialized agents helps optimize performance, avoid context dilution, and manage access permissions more effectively.
- **Voice AI architecture**: For low-resource languages such as Vietnamese, the three-stage model, STT - LLM - TTS, remains the most feasible and controllable option to ensure response quality.

**3.** AI is a teammate, not a replacement: In DevOps and human resource management, AI is designed to amplify human capabilities. DevOps Agents and Amazon Quick help significantly reduce incident resolution time, MTTR, and automate repetitive tasks, allowing engineers and HR professionals to focus on higher-level strategies.

**4.** Security is the top priority: When deploying AI in large enterprises, connections to third-party systems must follow the Zero Trust principle. Using VPC Connection, Interface Endpoint, and Private DNS to establish private connections through MCP is a necessary technical solution to ensure that enterprise data is not leaked through the public Internet.

**5.** Process optimization: Successfully deploying technology requires enterprises to be ready to change old operational processes, by more than 50%, to fit the new capabilities of AI.

### Application to Work

Based on the practical value gained from the FCAJ Community Day - June 2026 event, I have developed a specific plan to apply it to my work and studies as follows:

The knowledge gained from the event will be an important foundation for my learning process as well as my future career orientation.

In the near future, I plan to:

- Integrate AI into operational processes: Apply Multi-Agent thinking and AI solutions such as Amazon Quick to automate repetitive tasks, thereby optimizing work efficiency instead of only focusing on manual work.
- Prioritize secure architecture in AI applications: Apply the Private MCP Connection model, using VPC and Interface Endpoint for enterprise AI integration projects, ensuring compliance and data security according to the Zero Trust principle.
- Develop an execution mindset: Focus on building MVPs (Minimum Viable Products) or POCs (Proofs of Concept) to validate solutions directly in real environments instead of spending too much time on theory alone.
- Standardize development processes according to Enterprise standards: Apply knowledge of version management, Audit Logs, and Human-in-the-loop processes to software projects to ensure that systems have quality control capabilities and are easy to maintain.
- Optimize incident resolution capabilities: Use observability techniques and automate root cause investigation to minimize incident resolution time, MTTR, for the infrastructure systems that I manage.
- Combine diverse ecosystems: Not being limited to a single platform, I will leverage the diverse connectivity capabilities through MCP of AI tools to flexibly integrate with many existing systems, such as Jira, Slack, and Microsoft Suite, helping AI become a true central assistant.
- Improve comprehensive professional capabilities: Alongside mastering AI services on AWS, I will continuously strengthen my foundation in Cloud Infrastructure, System Design, and DevOps to ensure that the AI systems I build always achieve maximum reliability and scalability.

### Experience During the Event

The FCAJ Community Day event was organized professionally with many highly practical sharing sessions, focusing on issues that enterprises are interested in within Cloud Computing and AI. The program had a lively atmosphere with the participation of many engineers, experts, and students who share a passion for technology, creating favorable conditions for networking and learning.

What impressed me the most was that the speakers not only introduced theory but also shared many practical experiences from product development, system deployment, and solving issues arising in production environments. In particular, the sharing sessions on Multi-Agent System architecture, DevOps Agent solutions, and how to build secure Private MCP connections gave me a clearer view of how AI technologies are applied in enterprises.

Through the event, I not only gained more professional knowledge but also better understood the skills that enterprises are looking for in a Cloud or AI engineer. This was a meaningful experience that gave me more motivation to continue learning, improve my professional skills, and better prepare for my career direction in Cloud Computing, DevOps, and Artificial Intelligence.

### Images Proving Participation in the Event

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_1.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_2.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_3.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_4.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_5.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_6.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_7.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_8.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_9.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_15.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_11.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_12.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_13.png)

![FCAJ Community Day](/workshop-fcaj-intern/images/4-EventParticipated/4.4-Event4/event_14.png)