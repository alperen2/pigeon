---
layout: home

hero:
  name: Pigeon
  text: Agentic To Do Tracker
  tagline: Capture a thought in a second. Tasks stay plain Markdown, and the AI agents you connect pick them up and hand work back.
  image:
    src: /pigeon-mark.svg
    alt: Pigeon
  actions:
    - theme: brand
      text: Download on the Mac App Store
      link: https://apps.apple.com/app/pigeon-agentic-to-do/id6760581883
    - theme: alt
      text: Get Started
      link: /getting-started
    - theme: alt
      text: Connect an agent
      link: /agents
    - theme: alt
      text: Support
      link: /support

features:
  - title: Minimal by design
    details: Pigeon stays focused on fast capture and light triage instead of becoming a full task manager.
  - title: Plain Markdown files
    details: Tasks are lines in .md files in a folder you choose. Open them in any editor, sync them however you like.
  - title: Works with your AI agents
    details: Optionally connect Claude, ChatGPT or any MCP client through Pigeon Cloud. Agents take tasks meant for them and hand the next step back to you.
---

<script setup>
import { withBase } from "vitepress"
</script>

<div class="promo-video">
  <video controls playsinline preload="metadata" :poster="withBase('/media/pigeon-promo-poster.jpg')" aria-label="Pigeon in 40 seconds">
    <source :src="withBase('/media/pigeon-promo.mp4')" type="video/mp4">
  </video>
</div>
