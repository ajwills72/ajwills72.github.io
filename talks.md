---
layout: page
title: Talks
subtitle: Selected talks I have given
---

I generally give a few research-related talks a year, and have done so for about 25 years. I'm slowly adding them to this page, as time permits.

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
 
