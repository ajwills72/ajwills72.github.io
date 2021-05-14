---
layout: page
title: Lab
subtitle: Current members
---

{% for person in site.lab %}
  <img src="{{ person.thumbnail-img }}" alt="{{ person.surname }}" style="width:64px;">
  <b><a href="{{ person.link }}">{{ person.first-name }} {{ person.surname }}</a></b>: <i>{{ person.position }}</i>
  <p>{{ person.content | markdownify }}
{% endfor %}


