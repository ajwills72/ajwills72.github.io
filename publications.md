---
layout: page
title: Publications
subtitle: Page under construction
---

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
 
## OLD SCHOOL

Click on the title to access the full text of the article, plus any other public resources relating to the publication (e.g. raw data, analysis scripts). 


## Preprints

Inkster, A., Mitchell, C. J., Schlegelmilch, R., & Wills, A. J. [Effect of a context shift on the inverse base rate effect](pu075.md).

Inkster, A.B., Milton, F., Edmunds, C.E.R., Benattayallah, A., & Wills, A.J. [Neural correlates of the inverse base-rate effect](pu073.md).

Edmunds, C.E.R., Inkster, A.B., Jones, P.M., Milton, F., & Wills, A.J. [Absence of cross-modality analogical transfer in perceptual categorization](pu008.md).


## 2020s

Seabrooke, T., Mitchell, C. J., Wills, A. J., & Hollins, T. J. (in press). [Pretesting boosts recognition, but not cued recall, of targets from unrelated word pairs](pu060.md). Psychonomic Bulletin and Review. Accepted: 26 November 2019.

Spicer, S.G., Mitchell, C.J., Wills, A.J., & Jones, P.M. (2020). [Theory protection in associative learning: humans maintain certain beliefs in a manner that violates prediction error](pu048.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 46_, 151-161. Accepted: 19 July 2019. Published: April 2020.

Wills, A.J., Ellett, L., Milton, F., Croft, G., & Beesley, T. (2020). [A dimensional summation account of polymorphous category learning](pu077.md). _Learning and Behavior, 48_, 66-83. Accepted: 23 December 2019. Published: 13 March 2020.

Milton, F., McLaren, I.P.L., Copestake, E., Satherley, D., & Wills, A.J. (2020). [The effect of pre-exposure on overall similarity categorization](pu003.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 46_, 65-82. Accepted: 3 August 2019. Published: January 2020.

## 2010s

Wills, A.J., Edmunds, C.E.R., Le Pelley, M.E., Milton, F., Newell, B.R., Dwyer, D.M., & Shanks, D.R. (2019). [Dissociable learning processes, associative theory, and testimonial reviews: A comment on Smith and Church (2018)](pu066.md). _Psychonomic Bulletin & Review, 26_, 1988-1993. Accepted: 1 July 2019. Published: 13 August 2019.

Seabrooke, T., Mitchell, C.J., Wills, A.J., Waters, J.L., & Hollins, T.J. (2019). [Selective effects of errorful generation on recognition memory: The role of motivation and surprise](pu057.md). _Memory, 27_, 1250-1262. Accepted: 16 July 2019. Published: 1 August 2019.

Wills, A.J. (2019). [Open science, open source and R](pu061.md). _Linux Journal, 295_, 166-176. Accepted: 1 January 2019. Published: 19 February 2019.

Seabrooke, T., Hollins, T.J., Kent, C., Wills, A.J., & Mitchell, C.J. (2019). [Learning from failure: Errorful generation improves memory for items, not associations](pu038.md). _Journal of Memory and Language, 104_, 70-82. Accepted: 2018-10-04. Published: 19 October 2018.

Seabrooke, T., Wills, A.J., Hogarth, L., & Mitchell, C.J. (2019). [Automaticity and cognitive control: Effects of cognitive load on cue-controlled reward choice](pu032.md). _Quarterly Journal of Experimental Psychology, 72_, 1507-1521. Accepted: 5 August 2018. Published: 18 September 2018.

Schlegelmilch, R., Wills, A.J., & von Helversen, B. (2018). [CALM - A Process Model of Category Generalization, Abstraction and Structuring](pu043.md). In T. Rogers, M. Rau, X. Zhu, & C.W. Kalish (Eds.). _Proceedings of the 40th Annual Conference of the Cognitive Science Society_ (pp. 2436-2441). Austin, TX: Cognitive Science Society. Accepted: 13 April 2018. Published: August 2018.

Sambrook, T.D., Wills, A.J., Hardwick, B., & Goslin, J. (2018). [Model-free and model-based reward prediction errors in EEG](pu034.md). _NeuroImage, 178_, 162-171. Accepted: 8 May 2018. Published: 24 May 2018.

Lea, S.E.G., Pothos, E.M., Wills, A.J., Leaver, L.A., Ryan, C.M.E., & Meier, C. (2018). [Multiple Feature Use in Pigeons’ Category Discrimination: The Influence of Stimulus Set Structure and the Salience of Stimulus Differences](pu035.md). _Journal of Experimental Psychology: Animal Learning and Cognition, 44_, 114-127. Accepted: 27 January 2018. Published: April 2018.

Edmunds, C.E.R., Milton, F., & Wills, A.J. (2018). [Due process in dual process: Model-recovery simulations of decision-bound strategy analysis in category learning](pu012.md). _Cognitive Science, 42_, 833-860. Accepted: 18 Jan 2018. Published: 23 March 2018.

Edmunds, C.E.R., Wills, A.J., & Milton, F. (2019). [Initial training with difficult items does not facilitate category learning](pu010.md). _Quarterly Journal of Experimental Psychology, 72_, 151-167. Accepted: 12 July 2017. Published online: 1 January 2018. Issue published: 1 February 2019. 

Edmunds, C.E.R., Milton, F., & Wills, A.J. (2017). [Due process in dual process: A model-recovery analysis of Smith et al. (2014)](pu014.md). In A. Gunzelmann, A. Howes, T. Tenbrink, & E.J. Davelaar (Eds.). _Proceedings of the 39th Annual Conference of the Cognitive Science Society_ (pp. 1979-1984). Austin, TX: Cognitive Science Society. Accepted: 11 April 2017. Published: August 2017.

Longman, C.S., Milton, F., Wills, A.J., & Verbruggen, F. (2018). [Transfer of learned category-response associations is modulated by instruction](pu005.md). _Acta Psychologica, 184_, 144-167. Accepted: 11 April 2017. Published: 25 April 2017.

Wills, A.J., & Hollins, T.J. (2017). [In defence of effect-centric research](pu011.md). _Journal of Applied Research in Memory and Cognition, 6_, 43-46. Accepted: 31 October 2016. Published: 30 March 2017.

Wills, A.J., O'Connell, G., Edmunds, C.E.R., & Inkster, A.B. (2017). [Progress in modeling through distributed collaboration: Concepts, tools, and category-learning examples](pu002.md). _Psychology of Learning and Motivation, 66,_ 79-115. Accepted: 14 July 2016. Published: 6 February 2017.

Milton, F., Bealing, P., Carpenter, K.L., Bennattayallah, A., & Wills, A.J. (2017). [The neural correlates of similarity- and rule-based generalization](pu172.md). _Journal of Cognitive Neuroscience, 29_, 150-166. Accepted: 26 July 2016. Published: 30 November 2016.

Lawson, R., Chang, F., & Wills, A. J. (2017). [Free classification of large sets of everday objects is more thematic than taxonomic](pu171.md). _Acta Psychologica, 172_, 26-40. Accepted: 1 November 2016. Published: 15 November 2016.

O'Connell, G., Myers, C.E., Hopkins, R.O., McLaren, R.P., Gluck, M.A., & Wills, A.J. (2016). [Amnesic patients show superior generalization in category learning](pu170.md). _Neuropsychology, 30_, 915–919. Published: November 2016.

Le Pelley, M.E., Mitchell, C.J., Beesley, T., George, D.N., & Wills, A.J. (2016). [Attention and associative learning in humans: An integrative review](pu169.md). _Psychological Bulletin, 142_, 1111-1140. Published: October 2016.

Edmunds, C.E.R., Wills, A.J., & Milton, F.N. (2016). [Memory for exemplars in category learning](pu168.md). In A. Papfragou, D. Grodner, D. Mirman, & J.C. Trueswell (Eds.). _Proceedings of the 38th Annual Conference of the Cognitive Science Society_ (pp. 2243-2248). Austin, TX: Cognitive Science Society. Published: August 2016.

Edmunds, C.E.R., & Wills, A.J. (2016). [Modeling category learning using a dual-system approach: A simulation of Shepard, Hovland and Jenkins (1961) by COVIS](pu167.md). In A. Papfragou, D. Grodner, D. Mirman, & J.C. Trueswell (Eds.). _Proceedings of the 38th Annual Conference of the Cognitive Science Society_ (pp. 69-74). Austin, TX: Cognitive Science Society. Published: August 2016.

Carpenter, K., Wills, A.J., Bennattayallah, A., & Milton, F. (2016). [A comparison of the neural correlates that underlie rule-based and information-integration category learning](pu166.md). _Human Brain Mapping, 37_, 3557–3574. Published: 20 May 2016.

Roberts, H., Watkins, E., & Wills, A.J. (2017). [Does rumination cause "inhibitory" deficits?](pu165.md) _Psychopathology Review, 4_, 341-376. Accepted: 28 January 2015. Published: 5 May 2016.

Maes, E., De Filippo, G., Inkster, A., Lea, S.E.G., De Houwer, J., D'Hooge, R., Beckers, T., & Wills, A.J. (2015). [Feature- versus rule-based generalization in rats, pigeons and humans](pu164.md). _Animal Cognition, 18_, 1267-1284. Published: 19 July 2015.

Wills, A.J., Inkster, A.B., & Milton, F. (2015). [Combination or Differentiation? Two theories of processing order in classification](pu163.md). _Cognitive Psychology, 80_, 1-33. Published: 8 June 2015.

Hogarth, L., Zhimin, H., Chase, H.W., Wills, A.J., Troisi II, J., Leventhal, M., Mathew, A.R., & Hitsman, B. (2015). [Negative mood reverses devaluation of goal-directed drug-seeking favouring an incentive learning account of drug dependence](pu162.md). _Psychopharmacology, 232_, 3235-3247. Published: 5 June 2015.

Edmunds, C.E.R., Milton, F., & Wills, A.J. (2015). [Feedback can be superior to observational training for both rule-based and information-integration category structures](pu161.md). _Quarterly Journal of Experimental Psychology, 68_, 1203-1222. Published: 9 Jan 2015

Yeates, F., Wills, A.J., Jones, F.W., & McLaren, I.P.L. (2015). [State trace analysis: Dissociable processes in a connectionist network?](pu160.md) _Cognitive Science, 39_, 1047-1061. Published: 12 October 2014.

Inkster, A. B., Milton, F. N., & Wills, A. J. (2014). [Does incidental training increase the prevalence of overall similarity classification? A re-examination of Kemler Nelson (1984)](pu159.md). In P. Bello, M. Guarini, M. McShane, & B. Scassellati (Eds.). _Proceedings of the 36th Annual Conference of the Cognitive Science Society_ (pp. 649-653). Austin, TX: Cognitive Science Society. Published: August 2014.

Milton, F., Copestake, E., Satherley, D., Stevens, T., & Wills, A. J. (2014). [The effect of pre-exposure on family resemblance categorization for stimuli of varying levels of perceptual difficulty](pu158.md). In P. Bello, M. Guarini, M. McShane, & B. Scassellati (Eds.). _Proceedings of the 36th Annual Conference of the Cognitive Science Society_ (pp. 1018-1023). Austin, TX: Cognitive Science Society. Published: August 2014.

Carmantini, G. S., Cangelosi, A., & Wills, A. (2014). [Machine learning of visual object categorization: An application of the SUSTAIN model](pu157.md). In P Bello, M Guarini, M McShane, & B Scassellati (Eds.). _Proceedings of the 36th Annual Conference of the Cognitive Science Society_ (pp. 290-295). Austin, TX: Cognitive Science Society. Published: August 2014.

Wills, A.J., Lavric, A., Hemmings, Y., & Surrey, E. (2014). [Attention, predictive learning, and the inverse base-rate effect: Evidence from event-related potentials](pu156.md). _NeuroImage, 87_, 61-71. Published online: 2 November 2013.

Roberts, H., Watkins, E.R., & Wills, A.J. (2013). [Cueing an unresolved personal goal causes persistent ruminative self-focus: an experimental evaluation of control theories of rumination](pu155.md). _Journal of Behavior Therapy and Experimental Psychiatry, 44_, 449-455. Published: December 2013.

Wills, A.J., Milton, F., Longmore, C.A., Hester, S., & Robinson, J. (2013). [Is overall similarity classification less effortful than single-dimension classification?](pu154.md) _Quarterly Journal of Experimental Psychology, 66_, 299-318. Published: 17 August 2012.

Wills, A.J., Longmore, C.A., & Milton, F. (2013). [Impulsivity and overall similarity classification](pu153.md). In M. Knauff, M. Pauen, N. Sebanz, & I. Wachsmuth (Eds.). _Proceedings of the 35th Annual Conference of the Cognitive Science Society_ (pp. 3783-3788). Austin, TX: Cognitive Science Society. Published: August 2013.

Yeates, F., Jones, F.W., Wills, A.J., Aitken, M.R.F., & McLaren, I.P.L. (2013). [Implicit learning: A demonstration and a revision to a novel SRT paradigm](pu152.md). In M. Knauff, M. Pauen, N. Sebanz, & I. Wachsmuth (Eds.). _Proceedings of the 35th Annual Conference of the Cognitive Science Society_ (pp. 3829-3834). Austin, TX: Cognitive Science Society. Published: August 2013.

Wills, A.J. (2013). [Models of categorization](pu151.md). In D. Reisberg (Ed.). Oxford Handbook of Cognitive Psychology (pp. 346-357). Oxford: Oxford University Press. Published: June 2013.

Yeates, F., Wills, A.J., McLaren, R.P., & McLaren, I.P.L. (2013). [Modeling human sequence learning under incidental conditions](pu150.md). _Journal of Experimental Psychology: Animal Behavior Processes, 39_, 166-173. Published: April 2013.

Newell, B.R., Moore, C.P., Wills, A.J., & Milton, F. (2013). [Reinstating the frontal lobes? Having more time to think improves 'implicit' perceptual categorization. A comment on Filoteo, Lauritzen and Maddox (2010)](pu149.md). _Psychological Science, 24_, 386-389. Published: 6 February 2013.















_Publications are ordered by date of first publication (usually online publication). In some cases, this results in them being out of order in terms of the year the journal issue was published_.
