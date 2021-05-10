---
layout: page
title: Publications
subtitle: Page under construction
---


## Preprints

Inkster, A., Mitchell, C. J., Schlegelmilch, R., & Wills, A. J. [Effect of a context shift on the inverse base rate effect](pu075.md).

Inkster, A.B., Milton, F., Edmunds, C.E.R., Benattayallah, A., & Wills, A.J. [Neural correlates of the inverse base-rate effect](pu073.md).

Edmunds, C.E.R., Inkster, A.B., Jones, P.M., Milton, F., & Wills, A.J. [Absence of cross-modality analogical transfer in perceptual categorization](pu008.md).

Seabrooke, T., Mitchell, C. J., Wills, A. J., & Hollins, T. J. (in press). [Pretesting boosts recognition, but not cued recall, of targets from unrelated word pairs](pu060.md). Psychonomic Bulletin and Review. Accepted: 26 November 2019.

### Script generated

{% for paper in site.publications reversed %}
  <p>{{ paper.content | markdownify }}
  <div align="right">
  {% unless paper.pdf == "/no-text" %}
  <a href="{{ paper.pdf }}">Full text</a>
  {% endunless %}
  {% unless paper.osr == "/no-osr" %}
   : <a href="{{ paper.osr }}">Repository</a>
  {% endunless %}
  </div>
  </p>
{% endfor %}
 

_Publications are ordered by date of first publication (usually online publication). In some cases, this results in them being out of order in terms of the year the journal issue was published_.
