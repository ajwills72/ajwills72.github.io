---
layout: page
title: Co-authors
subtitle: People I've published with
---

I've worked with a lot of great people since I started my academic career. This page celebrates those who ended up co-authoring one or more papers with me. 

{% for person in site.people %}
  <img src="{{ person.thumbnail-img }}" alt="{{ person.surname }}" style="width:64px;">
  <b><a href="{{ person.link }}">{{ person.first-name }} {{ person.surname }}</a></b>: <i>{{ person.position }}</i>
  <p>{{ person.content | markdownify }} We have co-authored {{ person.co-count }} publications.</p>
{% endfor %}

