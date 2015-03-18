---
layout: page
title: Textos
permalink: /txt/
---

<ul>
{% for page in site.pages %}
{% if page.category == "txt" %}
  <li> [{{page.title}}]({{site.baseurl}}{{page.url}})</li>
{% endif %}
{% endfor %}
</ul>
