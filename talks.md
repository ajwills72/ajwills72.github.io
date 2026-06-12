---
layout: page
title: Talks
subtitle: Fairly comprehensive list of my research-related talks
---

I generally give a few research-related talks a year, and have done so for 30 years. I believe this to be a fairly complete list of talks given outside my home institution (plus a few inside it).

## Selected talks

{% for talk in site.talks reversed %}
  <p>{{ talk.content | markdownify }}
  <div align="right">
  {% unless talk.poster == "/no-poster" %}
  <a href="{{ talk.poster }}">Poster</a>
  {% endunless %}
  {% unless talk.slides == "/no-slides" %}
  <a href="{{ talk.slides }}">Slides</a>
  {% endunless %}
  {% unless talk.video == "/no-video" %}
  <a href="{{ talk.video }}">Video</a>
  {% endunless %}
  {% unless talk.osr == "/no-osr" %}
   : <a href="{{ talk.osr }}">Repository</a>
  {% endunless %}
  </div>
  </p>
{% endfor %}
 
