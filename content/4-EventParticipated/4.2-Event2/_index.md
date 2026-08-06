---
title: "Event 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 4.2. </b> "
---

# Event Report: "FCAJ Community Day"

- Time: 9:00 AM - 12:00 PM, May 23, 2026.
- Floor 26, Bitexco Financial Tower, No. 2 Hai Trieu Street, Ben Nghe Ward, District 1, Ho Chi Minh City, Vietnam.

### Purpose of the Event

The **FCAJ Community Day** event was organized not only to share in-depth knowledge about technology, **Cloud (AWS)**, and **AI**, but also to create a space where the technology community could connect, network, and inspire one another to learn.

### Participation Role

At this event, I participated as an attendee, listening to and absorbing practical knowledge shared by leading industry experts, thereby gaining insights into the latest technology trends.

### List of Speakers

This edition of **FCAJ Community Day** featured many leading experts and engineers in the fields of **Cloud Computing**, **DevOps**, and **AI**. The event began with an inspiring presentation by **Nguyen Gia Hung** (Head of Solutions Architect - Vietnam & Cambodia). This was followed by the main speakers:

- **Tinh Truong** - Platform Engineer at GoTymeX.
- **Anh Pham** - Cloud Consultant at G-AsiaPacific Vietnam.
- **Thinh Nguyen** - DevOps Engineer at STYL Solutions Pte. Ltd.
- **Team VIB** - Champion of the **LotusHacks** competition.
- **Duc Dao** - Solution Architect at Cloud Kinetics.
- **Vy Lam** - Senior Business Systems Analyst at VPBank.

### Content

The event was divided into multiple sessions covering different topics, focusing on modern technologies on the AWS platform.

#### Perspective on the Job Market

AI is making software development more affordable, leading to a dramatic increase in the demand for software and related jobs. To stay competitive, engineers need to acquire domain-specific knowledge and build real-world products that demonstrate their capabilities instead of relying solely on demos.

#### Topic 1: Context Is Everything: Making AI Actually Work for You - Tinh Truong

This session discussed the importance of context in AI. In most cases, poor AI responses are not caused by a weak model but by insufficient context. Participants were advised to avoid the **Internet Puller** mistake (stuffing AI with large amounts of irrelevant documents).

A good prompt should follow the structure:

**Goal - Relevant Data - Constraints - Success Criteria**

#### Topic 2: Friendly AI Assistant with Amazon Quick - Anh Pham

This topic focused on leveraging AI to optimize business productivity, specifically through AI-powered assistants.

The main points included:

- Solving time-consuming tasks: The speaker emphasized that organizations often spend a significant amount of time collecting data and preparing reports manually. **Amazon Quick** was introduced as an intelligent solution to reduce this workload.

- Ecosystem integration: **Amazon Quick** integrates with popular ecosystems such as **Microsoft (PowerBI, Word, Outlook, Teams)** and **Google (Gmail, Calendar)** through **Platform Agents**, allowing users to build their own AI Agents for personal or business purposes.

- Key features:<br>
&bull; **BI (Business Intelligence)**: Automatically performs in-depth analysis once input data is received.<br>
&bull; **Insight & Chat**: Enables direct interaction with data to better understand information.<br>
&bull; **Automation**: Fully automates workflows through **automation flows**.<br>

- Live demonstration: The demo showcased the ability to import Excel data to automatically generate dashboards and instruct AI to summarize meeting recordings, enabling even non-technical users to process complex data with ease.

#### Topic 3: From Edge To Origin: CloudFront as Your Foundation - Thinh Nguyen

This session focused on the role of **Amazon CloudFront**, highlighting that it is not merely a traditional CDN service but also a comprehensive platform for application security and optimization.

The main topics included:

1. Advanced security capabilities:

- **VPC Private Origin**: Creates a dedicated connection from **CloudFront** to a **private subnet**, hiding backend infrastructure from the public Internet.

- **Mutual TLS**: Requires certificate authentication from both the client and the server, making it suitable for financial systems or copyrighted content.

- **Geo/IP-based attack blocking**: Reduces server workload by blocking malicious requests directly at the **Edge** layer before they reach the **Origin**.

2. Performance optimization:

- **Content Compression**: Compresses content to significantly reduce payload size (up to 82%), improving page loading speed.

- **Reducing GPU workload on EC2**: CloudFront offloads tasks such as TCP and TLS handshakes from EC2, allowing servers to focus solely on business logic.

3. Multi-layer caching: A caching mechanism across **Points of Presence (PoPs)** that efficiently distributes content and reduces latency for end users regardless of their geographic location.

#### Topic 4: 36 hrs with LotusHacks – Building UTMorpho from Idea to Reality - Team VIB

This session shared the journey of building a product within 36 hours during Vietnam's largest **Hackathon**. The key points included:

1. **Product idea (UTMorpho)**: The team focused on solving the problem of wasted time and tokens when using AI for UI design. Instead of asking AI to regenerate the entire interface whenever small modifications were needed, **UTMorpho** allows users to edit the generated interface directly.

2. System architecture: The team adopted a **serverless** architecture combined with three specialized AI Agents to process user input:

- Agent 1: Analyzes user-provided images or sketches.
- Agent 2: Generates layouts, CSS, and component structures.
- Agent 3: Produces the final UI code based on the requirements.

3. Challenges encountered:

- Token limits: Continuous AI usage frequently resulted in **token limit** errors during development.

- Over-generation: AI sometimes generated unnecessary features, making the codebase more difficult to manage.

- Exhaustion: Time pressure and fatigue around 4–5 AM forced the team to change their strategy by focusing on optimizing the editing experience instead of adding too many features.

4. Lessons learned: The team emphasized the importance of keeping ideas simple and focusing on solving one specific problem instead of trying to implement too many complex features within a limited timeframe.

#### Topic 5: Non-Determinism of "Deterministic" LLM Settings - Duc Dao

This session explored the probabilistic nature of Large Language Models (LLMs) and the common misconceptions about their *deterministic* behavior in software engineering.

The main topics included:

1. The nature of LLMs: At their core, LLMs are **probabilistic engines**. They generate the next token by scoring and ranking possible candidates in the vocabulary rather than following a rigid logical process.

2. The misconception of *Temperature = 0*: Many developers believe that setting *temperature = 0* makes the model completely deterministic (identical input always produces identical output). In reality, even with *temperature = 0*, slight differences may still occur due to GPU computation and underlying software libraries.

3. Challenges in production:

- Variations in generated outputs may affect critical applications where absolute consistency is required.

- Some models operating at *temperature = 0* (*greedy decoding* mode) may repeatedly generate the same tokens.

4. Mitigation strategies:

- Testing and validation: Emphasize comprehensive testing to ensure the system can properly handle unexpected outputs.

- **Downstream** design: Services consuming LLM outputs should be designed to handle variations gracefully rather than expecting perfect consistency.

- Optimized parameters: In some cases, setting *temperature = 0.1* instead of 0 produces more stable outputs and helps avoid repetitive generation.

- Using specialized features: Utilize features such as **JSON Mode** provided by API vendors to enforce structured output formats.

5. Key takeaway: Always read the **official documentation** for each specific model instead of relying solely on general experience, as different models may behave differently.

#### Topic 6: Enterprise-Grade Multi-Agent System: The Case of Startup Credit Scoring - Vy Lam

For me, this was the most outstanding session of the event. It focused on designing enterprise-grade **Multi-Agent Systems** for startup credit scoring.

The main topics included:

1. Business challenges: Traditional credit-scoring models are often unsuitable for startups because they lack three years of financial history, physical collateral, and established credit records. The system therefore needs to leverage alternative data sources such as intellectual property, growth potential, and founder information.

2. Multi-Agent architecture:

- Instead of relying on a single Agent, which is limited by context windows and cannot effectively handle multiple areas of expertise, the system is divided into specialized Agents: **Financial Analyst**, **Research Agent**, **Team Evaluator**, and **Risk Assessor**.

- A **Manager Agent** coordinates tasks and consolidates results from all specialized Agents.

3. Enterprise standards:

- **Security & Compliance**: Emphasizes compliance with security regulations, customer data protection, and preventing **MCP attack vectors**.

- **Audit Trail**: Every AI decision must be traceable for auditing purposes, especially when dealing with regulatory authorities.

- **Human-in-the-loop**: AI serves only as a decision-support tool, while humans remain responsible for reviewing and approving final lending decisions.

4. Deployment experience:

- The deployment process consists of the following stages: Build Core -> Internal Testing -> SIT (System Integration Testing) -> UAT (User Acceptance Testing) -> Pilot -> Scale.

5. Technical recommendations:

- Focus on backend engineering skills rather than AI alone, because secure data management and databases are the true foundation of enterprise systems.

- Use **Infrastructure as Code** (Terraform) to manage infrastructure instead of performing manual configurations, making deployments reproducible and easier to version-control.

6. Key takeaway: A successful system should not only function correctly but also be secure, reliable, and designed to serve people.

### What I Learned

After attending the event, I gained valuable knowledge and practical insights into the development trends of Cloud Computing and AI in enterprises, including:

- Understanding that AI does not completely replace software engineers but is transforming the way software is developed. What truly matters is not only knowing how to use AI but also possessing domain expertise and the ability to solve real-world problems.
- Recognizing the importance of **Prompt Engineering**, especially the need to provide sufficient context so that AI can generate accurate and relevant responses.
- Learning how enterprises leverage AI services on AWS to build AI assistants, automate workflows, and support decision-making.
- Understanding the new capabilities of **Amazon CloudFront** in strengthening security, optimizing performance, and reducing backend workload, rather than viewing it solely as a traditional CDN service.
- Learning practical experience in building AI products during a Hackathon, particularly in optimizing development time, defining an appropriate project scope, and focusing on solving users' real problems.
- Gaining a deeper understanding of the probabilistic nature of Large Language Models (LLMs), the limitations of treating LLMs as completely "deterministic," and methods to reduce output inconsistencies in production environments.
- Learning the design principles of **Multi-Agent Systems** for enterprise applications, where each Agent performs a specialized role under the coordination of a central Manager Agent.
- Realizing that when deploying AI in enterprise environments, factors such as security, Audit Trail, Human-in-the-loop, and regulatory compliance are just as important as the AI model itself.
- Understanding the role of **Infrastructure as Code (Terraform)** in infrastructure management, enabling automated deployments, version control, and scalable system management.

### Application to Future Work

The knowledge gained from this event will serve as an important foundation for both my academic studies and my future career development.

In the future, I plan to:

- Continue studying and practicing AI services on the **Amazon Web Services (AWS)** platform, especially solutions for building Generative AI applications.
- Apply **Prompt Engineering** principles to improve the quality of interactions with Large Language Models in both learning and software development.
- Explore **Amazon CloudFront**, Edge security solutions, and performance optimization techniques in greater depth for future website and cloud deployment projects.
- Practice building **Multi-Agent Systems** to solve complex problems while incorporating Human-in-the-loop workflows to improve system reliability.
- Continue using **Terraform** and other Infrastructure as Code tools in cloud projects to automate infrastructure deployment and management.
- Place greater emphasis on developing real-world projects instead of focusing solely on theoretical knowledge, thereby building a portfolio that demonstrates my technical capabilities when applying for internships or full-time positions.
- Continue strengthening my knowledge of Backend Development, Cloud Computing, DevOps, and System Design in addition to AI, building a solid technical foundation for developing enterprise-grade AI systems.

### Event Experience

The event was professionally organized, featuring multiple highly practical sessions focused on the challenges that enterprises are currently addressing in the fields of Cloud Computing and AI. The atmosphere was vibrant, with the participation of engineers, industry experts, and students who share a passion for technology, creating an excellent environment for networking and learning.

What impressed me the most was that the speakers did not only present theoretical concepts but also shared valuable real-world experience in product development, system deployment, and solving production-level challenges. In particular, the sessions on Multi-Agent Systems, CloudFront, and the Hackathon experience provided me with a much clearer understanding of how AI technologies are applied in enterprise environments.

Through this event, I not only expanded my technical knowledge but also gained a better understanding of the skills that companies expect from Cloud and AI engineers. It was a meaningful experience that further motivated me to continue learning, improve my technical expertise, and better prepare for my future career in Cloud Computing, DevOps, and Artificial Intelligence.

### Event Participation Photos

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_1.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_2.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_3.png)

- Below are some additional photos from the event, captured by the **AWS Study Group** administrators:

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_4.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_5.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_6.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_7.png)

![Event Participated](/workshop-fcaj-intern/images/4-EventParticipated/4.2-Event2/event_8.png)