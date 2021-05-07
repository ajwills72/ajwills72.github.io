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

### 2019

Wills, A.J., Edmunds, C.E.R., Le Pelley, M.E., Milton, F., Newell, B.R., Dwyer, D.M., & Shanks, D.R. (2019). [Dissociable learning processes, associative theory, and testimonial reviews: A comment on Smith and Church (2018)](pu066.md). _Psychonomic Bulletin & Review, 26_, 1988-1993. Accepted: 1 July 2019. Published: 13 August 2019.

Seabrooke, T., Mitchell, C.J., Wills, A.J., Waters, J.L., & Hollins, T.J. (2019). [Selective effects of errorful generation on recognition memory: The role of motivation and surprise](pu057.md). _Memory, 27_, 1250-1262. Accepted: 16 July 2019. Published: 1 August 2019.

Wills, A.J. (2019). [Open science, open source and R](pu061.md). _Linux Journal, 295_, 166-176. Accepted: 1 January 2019. Published: 19 February 2019.

Seabrooke, T., Hollins, T.J., Kent, C., Wills, A.J., & Mitchell, C.J. (2019). [Learning from failure: Errorful generation improves memory for items, not associations](pu038.md). _Journal of Memory and Language, 104_, 70-82. Accepted: 2018-10-04. Published: 19 October 2018.

Seabrooke, T., Wills, A.J., Hogarth, L., & Mitchell, C.J. (2019). [Automaticity and cognitive control: Effects of cognitive load on cue-controlled reward choice](pu032.md). _Quarterly Journal of Experimental Psychology, 72_, 1507-1521. Accepted: 5 August 2018. Published: 18 September 2018.

Edmunds, C.E.R., Wills, A.J., & Milton, F. (2019). [Initial training with difficult items does not facilitate category learning](pu010.md). _Quarterly Journal of Experimental Psychology, 72_, 151-167. Accepted: 12 July 2017. Published online: 1 January 2018. Issue published: 1 February 2019. 

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
