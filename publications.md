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

### 2018

Lea, S.E.G., Pothos, E.M., Wills, A.J., Leaver, L.A., Ryan, C.M.E., & Meier, C. (2018). [Multiple Feature Use in Pigeons’ Category Discrimination: The Influence of Stimulus Set Structure and the Salience of Stimulus Differences](pu035.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 44_, 114-127. Accepted: 27 January 2018. Published: April 2018.

Schlegelmilch, R., Wills, A.J., & von Helversen, B. (2018). [CALM - A Process Model of Category Generalization, Abstraction and Structuring](pu043.md). In T. Rogers, M. Rau, X. Zhu, & C.W. Kalish (Eds.). _Proceedings of the 40th Annual Conference of the Cognitive Science Society_ (pp. 2436-2441). Austin, TX: Cognitive Science Society. Accepted: 13 April 2018. Published: August 2018.

Sambrook, T.D., Wills, A.J., Hardwick, B., & Goslin, J. (2018). [Model-free and model-based reward prediction errors in EEG](pu034.md). _NeuroImage, 178_, 162-171. Accepted: 8 May 2018. Published: 24 May 2018.

Longman, C.S., Milton, F., Wills, A.J., & Verbruggen, F. (2018). [Transfer of learned category-response associations is modulated by instruction](pu005.md). _Acta Psychologica, 184_, 144-167. Accepted: 11 April 2017. Published: 25 April 2017.

Edmunds, C.E.R., Milton, F., & Wills, A.J. (2018). [Due process in dual process: Model-recovery simulations of decision-bound strategy analysis in category learning](pu012.md). _Cognitive Science, 42_, 833-860. Accepted: 18 Jan 2018. Published: 23 March 2018.


### 2017

Edmunds, C.E.R., Milton, F., & Wills, A.J. (2017). [Due process in dual process: A model-recovery analysis of Smith et al. (2014)](pu014.md). In A. Gunzelmann, A. Howes, T. Tenbrink, & E.J. Davelaar (Eds.). _Proceedings of the 39th Annual Conference of the Cognitive Science Society_ (pp. 1979-1984). Austin, TX: Cognitive Science Society. Accepted: 11 April 2017. Published: August 2017.


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
