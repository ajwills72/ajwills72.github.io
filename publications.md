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

### 2020

Spicer, S.G., Mitchell, C.J., Wills, A.J., & Jones, P.M. (2020). [Theory protection in associative learning: humans maintain certain beliefs in a manner that violates prediction error](pu048.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 46_, 151-161. Accepted: 19 July 2019. Published: April 2020.

Wills, A.J., Ellett, L., Milton, F., Croft, G., & Beesley, T. (2020). [A dimensional summation account of polymorphous category learning](pu077.md). _Learning and Behavior, 48_, 66-83. Accepted: 23 December 2019. Published: 13 March 2020.

Milton, F., McLaren, I.P.L., Copestake, E., Satherley, D., & Wills, A.J. (2020). [The effect of pre-exposure on overall similarity categorization](pu003.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 46_, 65-82. Accepted: 3 August 2019. Published: January 2020.


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
