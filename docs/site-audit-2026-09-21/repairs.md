# Site repairs — 21 September 2026

Owner: Sophie (Software developer).

## Delivery status

Repairs are implemented and tested in the local checkout. **They have not been committed, pushed or deployed.** The original audit remains an unchanged historical snapshot. All six items requiring Andy’s input are resolved. All 50 initially inconclusive external targets have now been reviewed with Andy. Item 34 is recorded as a known unresolved broken link (password-protected).

## Changes

- Addressed all 68 broken internal targets identified by the audit: corrected paths to existing PDFs, figures, media and datasets; restored a shared file-format guide; suppressed placeholder links and unavailable downloads; removed the broken optional SYD2 logo.
- Corrected two wrong-paper references after extracting and checking the PDF titles: Longman et al. (2018) now links to longman2017.pdf, and the legacy Wills et al. (2007) page now links to 2007Willsetal.pdf rather than the 2006 paper.
- Reconnected the 2005 edited book to its existing chapter-download page.
- Refreshed 21 of the 26 external URLs originally returning 404. Replacement URLs and evidence are below. DeepSim is explicitly documented as a private repository, so its unauthenticated 404 is expected and its link is retained.
- Recovered all four OJEPN PDFs from the journal's relocated archive; all downloaded successfully and their first-page titles match the cited articles.
- Publication and quote templates now suppress missing, empty and known placeholder values. Navigation dropdowns have unique IDs and correctly associated accessible names.
- Added language and mobile viewport metadata to 43 standalone legacy HTML source files (the original audit included directory/index.html aliases). Fixed the SONA/JATOS page's invalid layout, caught during the build.
- Changed the homepage wording to “navigation menu” and the visitor-counter attribution to HTTPS. The visitor counter remains enabled.
- Added a historical-status note to BRIC's 2021–2023 funding guidance, with a link to its current computing handbook. The handbook gives April 30, 2026 as the Azure VM decommissioning date.

## Validation

- Built with Jekyll 3.10.0, jekyll-paginate, jekyll-sitemap, jekyll-optional-front-matter and jekyll-relative-links using an isolated /tmp gem environment. No final build warnings.
- Parsed all **156 generated HTML files**: **zero unresolved local internal link targets, zero duplicate IDs, and zero pages missing language/viewport metadata**. Separate deployed projects whose links were successful in the baseline audit are excluded from local-file existence failures; their contents were not rebuilt here.
- git diff --check passed.
- Browser spot-checks at desktop and 390×844: homepage and dropdowns, Papers, a legacy research-data page and the new format guide. Outputs is now correctly labelled “OUTPUTS”; mobile navigation reaches Papers; no broken images or placeholder links on Papers; the verified Longman link is present. The legacy page fits the 390-pixel width and exposes lang=en and viewport metadata.
- Checked local paper titles for all repaired legacy Download PDF links. Network checks confirm availability, not future uptime. A few replacement sites restrict direct automated requests, as detailed below.

Evidence: validation.json, replacement-checks.json, external-repair-map.json; the original audit CSV/JSON remains alongside these. preview-build.rb and validate-preview.py record the checks used. Run them from the repository root after providing the listed Jekyll gems; the preview output is /tmp/andy-site-preview. The build helper also looks in /tmp/andy-site-gems. The validator uses the original results.json solely to recognise previously reachable, separately deployed projects.

## Missing resources

- Gregynog2004.pdf — resolved: Andy confirmed on 22 September 2026 that the slides are not known to survive and the absence of a link is deliberate. Keep wills-2004-wales.md with slides: /no-slides. No recovery action is required.
- eprime_convert_exe10.R / eprime_convert_exe010.R — resolved: at Andy’s request on 22 September 2026, the research page explicitly labels this a missing file, unavailable on the website with no known surviving copy. The script description remains; no recovery action is pending.

All six items requiring Andy’s input are resolved. No replacement scientific content was invented.

22 September 2026: At Andy’s request, removed the dead Book Cupboard hyperlink from “The Early Asimov”, retaining the shop name and surrounding text.

22 September 2026: Replaced Rebecca Lawson’s broken Liverpool profile link with the Google Scholar URL supplied by Andy: https://scholar.google.co.uk/citations?hl=en&user=9ox0z3oAAAAJ&view_op=list_works&sortby=pubdate. No change made to her biographical text.

## External-link decisions

22 September 2026: At Andy’s request, removed the hyperlinks for the following two citations, retaining their text:

- Greeking archaeological-sites article: https://greeking.me/blog/greek-history-culture/item/57-10-most-important-archaeological-sites-of-greece — citation text retained in naxos.md.
- Sean Anderson's panel-label article: http://seananderson.ca/2013/10/21/panel-letters.html — citation, plain-text URL, local analysis code and attribution retained.

All 50 initially inconclusive external targets have now been reviewed with Andy. Item 34 is a known unresolved broken link (password-protected). Automated access blocks, login requirements and transient/network errors do not demonstrate missing content. The dated 2022 peer-review policy and co-author biographies have not been rewritten without an editorial brief.

## Replacement provenance

| Original URL | Replacement | Verification |
|---|---|---|
| https://fold.ai/our-team/ | https://fold.eco/en/about/ | HTTP 200 |
| https://www.plymouth.ac.uk/staff/lenard-dome | https://lenarddome.com/ | HTTP 200 |
| https://www.gluck.edu/mark_bio.html | https://adrd.rutgers.edu/people/633/ | HTTP 200 |
| https://www.plymouth.ac.uk/staff/tim-hollins-2 | https://www.researchgate.net/profile/Timothy-Hollins-2 | HTTP 403; content/identity confirmed through indexed primary source; direct fetch restricted |
| https://www.canterbury.ac.uk/science-engineering-and-social-sciences/psychology-and-life-sciences/staff/Profile.aspx?staff=e60942d39c138260 | https://www.canterbury.ac.uk/people/fergal-jones | HTTP 200 |
| https://www.canterbury.ac.uk/science-engineering-and-social-sciences/psychology-and-life-sciences/psychology/staff/Profile.aspx?staff=549e189ce72fb760 | https://www.canterbury.ac.uk/people/britta-osthaus | HTTP 200 |
| https://www2.le.ac.uk/departments/npb/people/akw12/index | https://research.birmingham.ac.uk/en/persons/alice-welham/ | HTTP 200 |
| https://scholar.google.co.uk/citations?user=PeAkz6oAAAAJ | https://profiles.cardiff.ac.uk/staff/dwyerdm | HTTP 403; content/identity confirmed through indexed primary source; direct fetch restricted |
| https://core.ac.uk/download/pdf/193094737.pdf | https://pubmed.ncbi.nlm.nih.gov/8934685/ | HTTP 203; content/identity confirmed through indexed primary source; direct fetch restricted |
| https://towardsdatascience.com/reproducible-work-in-r-e7d160d5d198 | https://medium.com/data-science/reproducible-work-in-r-e7d160d5d198 | HTTP 403; content/identity confirmed through indexed primary source; direct fetch restricted |
| http://hdl.handle.net/10026.1/16905 | https://researchportal.plymouth.ac.uk/files/38965047/jones_mitchell_wills_spicer_2021_comment_on_chan.pdf | HTTP 403; content/identity confirmed through indexed primary source; direct fetch restricted |
| https://www.ojepn.com/images/2020/aa.pdf | https://ojepn.com/index.php/8-ojepn/images/2020/aa.pdf | HTTP 200 |
| https://www.ojepn.com/images/2020/2020-8639.pdf | https://ojepn.com/index.php/2-uncategorised/images/2020/2020-8639.pdf | HTTP 200 |
| https://www.ojepn.com/images/2021/2021-6623.pdf | https://ojepn.com/index.php/2-uncategorised/images/2021/2021-6623.pdf | HTTP 200 |
| https://www.ojepn.com/images/2022/2022-0404.pdf | https://ojepn.com/index.php/2-uncategorised/images/2022/2022-0404.pdf | HTTP 200 |
| http://www.willslab.co.uk/catlearn.html | /catlearn | Local file exists / deployed project checked |
| http://www.howtogeek.com/howto/31717/what-do-the-phrases-free-speech-vs.-free-beer-really-mean/ | https://www.gnu.org/philosophy/free-sw.html | HTTP 200 |
| https://brichandbook.readthedocs.io/en/latest/modelling.html | https://brichandbook.readthedocs.io/en/latest/bric/bricResources.html | HTTP 200 |
| http://www.willslab.co.uk/plym10/bsci.R | /willslab-dau/plym10/bsci.R | Local file exists / deployed project checked |
| https://www.computing.dcu.ie/~gjones/ | https://www.adaptcentre.ie/experts/gareth-jones/ | HTTP 200 |
| https://www.linkedin.com/in/ben-hardwick-63b929120/?originalSubdomain=uk | https://uk.linkedin.com/in/ben-hardwick-c-erghf-mciehf-63b929120 | Author profile linked from their own publication post |

Primary source examples: [OJEPN archive](https://ojepn.com/), [BRIC computing handbook](https://brichandbook.readthedocs.io/en/latest/bric/bricResources.html), [Ben Hardwick’s own paper announcement and profile link](https://www.linkedin.com/posts/ben-hardwick-c-erghf-mciehf-63b929120_model-free-and-model-based-reward-prediction-activity-6404407794757443585-5LM8).

## Handover

Review the source diff, publish through the normal GitHub Pages workflow when ready, then rerun live checks after deployment. The four external-link decisions are resolved. The E-Prime conversion script is explicitly marked missing; the Gregynog slides are intentionally unavailable. No claim is made that the live website already reflects these local repairs.

## Manual external-link review — 23 September 2026

First batch resolved from Andy’s decisions:

1. Steve Graham / Nurture Science Publishing: organization folded; removed hyperlink, retained entry. Coauthor template now renders names without a link when none is supplied.
2. Jan Zwickel: replaced SAP profile with https://www.linkedin.com/in/jan-zwickel-6b77b1aa/.
3. Tom Sambrook: replaced UEA profile with https://scholar.google.com/citations?user=aoOOyVkAAAAJ&hl=en.
4. Affect 4.0: replaced old software-site link with https://pubmed.ncbi.nlm.nih.gov/20178962/.
5. Kruschke EXIT model: replaced old PDF link with https://doi.org/10.1006/jmps.2000.1354.
6. Hostelbay Cyclades article: removed hyperlink, retained title.

Replacement destinations were supplied by Andy. After the first two batches, 38 original inconclusive targets remained to review. Changes remain local and unpublished.

Second batch (items 7–12), 23 September 2026: Andy confirmed Adam Leventhal (USC), Emmanuel Pothos (City), David George, Fraser Milton and Jan De Houwer (ResearchGate) pages are present; all five links retained. David Shanks’s UCL link was replaced with Andy’s supplied Google Scholar URL: https://scholar.google.com/citations?user=n3ulrqAAAAAJ&hl=en. Twelve of the original 50 inconclusive targets are now resolved; 38 remain to review.

Third batch (items 13–18), 23 September 2026:

- Stuart Spicer: Scholar replacement supplied by Andy, https://scholar.google.com/citations?hl=en&user=i7luT5MAAAAJ.
- Tom Beckers: Scholar replacement supplied by Andy, https://scholar.google.com/citations?hl=en&user=H_LiySwAAAAJ.
- Frederick Verbruggen: Scholar replacement supplied by Andy, https://scholar.google.com/citations?hl=en&user=GfHmv20AAAAJ.
- Lucy Hopewell: retain ResearchGate at Andy’s request because no alternative is available; not recorded as independently verified accessible.
- Mark Suret: Andy confirmed LinkedIn page works; retained.
- Kazuhiro Goto: Andy supplied the corrected Scholar URL, now applied: https://scholar.google.com/citations?user=zOYJnckAAAAJ&hl=en&oi=ao. Andy also confirmed David Shanks’s URL: https://scholar.google.com/citations?hl=en&user=n3ulrqAAAAAJ.

After the third batch, 18 of 50 had decisions recorded; 32 remained to review.

Fourth batch (items 19–24), 23 September 2026: Andy confirmed Angus Inkster, Christina Meier, Yvonne Hemmings and Elisa Maes profiles exist; retained their LinkedIn links. Fayme Yeates’s missing LinkedIn page was replaced with Andy’s supplied https://scholar.google.com/citations?user=wX9EdRYAAAAJ&hl=en. Edward Copestake’s missing LinkedIn page was replaced with Andy’s supplied https://www.researchgate.net/profile/Edward-Copestake. After the fourth batch, 24 of 50 had decisions recorded; 26 remained to review.

Fifth batch (items 25–30), 23 September 2026: Andy confirmed Garret O’Connell, Guido De Filippo, Katie Blake, Koh Zhisheng and Pippa Bealing LinkedIn profiles work; retained those five links. Kathryn Carpenter’s failed LinkedIn link was replaced with Andy’s supplied https://www.researchgate.net/profile/Kathryn-Carpenter-4. After the fifth batch, 30 of 50 had decisions recorded; 20 remained to review.

Sixth batch (items 31–36), 23 September 2026: Andy confirmed Rachel Baron and Stephen Oakeshott (LinkedIn), Ask Ubuntu installation/disk-space article, Mykonos climate page and Astronomy Cast Patreon page work; retained all five. Item 34, Jay Taala’s Linux drive-mounting guide, is now password-protected. Marked as a broken link at Andy’s request; URL retained with an explicit password-protected/broken-link notice on the Linux setup page. No replacement selected. After the sixth batch, 36 of 50 had been reviewed; 14 remained. Item 34 remains a known unresolved broken link.

Seventh batch (items 37–42), 23 September 2026: Andy confirmed all six links are working and open access: Human Brain Mapping DOIs 10.1002/hbm.24047 and 10.1002/hbm.25729; eLife article 36395 PDF; Open Mind DOI 10.1162/opmi_a_00208; Memory DOI 10.1080/09658211.2019.1647247; Exeter repository handle 10871/27115. All retained unchanged. After the seventh batch, 42 of 50 had been reviewed; eight remained. Item 34 remains recorded as broken/password-protected.

Final batch (items 43–50), 23 September 2026: Andy confirmed items 43–47, 49 and 50 work; retained all seven. Replaced item 48, the Sambrook et al. (2025) ScienceDirect link, with Andy’s supplied https://ueaeprints.uea.ac.uk/id/eprint/101480/. All 50 have now been reviewed. Item 34 remains explicitly marked broken/password-protected by decision; no other manual-review decisions remain pending. Changes are local and unpublished.
