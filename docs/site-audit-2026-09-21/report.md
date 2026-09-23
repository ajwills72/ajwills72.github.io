# Personal website audit — 21 September 2026

## Outcome

The audit found **68 distinct broken internal targets** and **26 external targets returning HTTP 404 on both checks**, plus one confirmed wrong-paper PDF link. External access restrictions and connection failures are listed separately and are not counted as confirmed broken content. No website fixes have been made.

Live site: https://www.andywills.info/  
Repository: https://github.com/ajwills72/ajwills72.github.io

## Coverage and method

- Inventoried the live sitemap (346 entries) plus public-looking HTML files in the checkout: 392 seed URLs requested, including PDF entries and explicit index.html aliases.
- Parsed 198 successful HTML seed URLs; these are URLs, not necessarily distinct content pages. Extracted 1,023 distinct HTTP(S) targets and requested 1,132 URLs in total, including seeds.
- Used GET requests with redirects, TLS verification, 18-second timeouts and a 15 MB per-response cap. Rechecked all 147 initially non-200 responses. One timeout recovered successfully; the 96 initial 404s persisted, of which 94 were linked targets and two were source-inventory candidates.
- Compared linked internal fragments against IDs/named anchors in available successful HTML responses: no missing internal fragment references found.
- Browser spot-checks: homepage at desktop and 390×844, Papers at 390×844, Teaching at desktop, and legacy PLY034 at 390×844. Mobile navigation opened and reached Papers successfully; no warning/error console entries were captured for the Papers and Teaching checks.
- Source review covered publication records/templates, navigation, missing-file candidates and placeholder strings.

### Limits

This was a sitemap/source inventory plus outgoing-link audit, not an unlimited recursive crawl of every external or separately hosted project. Linked RMINR/course sites were checked as destinations, not fully audited. CSS url() references, script-generated links, authenticated content, all external anchors, every PDF's contents, complete downloaded archive integrity and exhaustive accessibility/performance testing were outside coverage. Some responses hit download-size/time limits; see error fields in evidence. HTTP 200 alone does not prove a page still contains the intended content. Older index.html aliases are retained in the evidence. Missing viewport metadata is a compatibility concern, not proof of visual failure on every device.

## Domain and replacement checks

The GitHub Pages URL, HTTP www URL and HTTPS bare domain all redirected successfully to https://www.andywills.info/. Verified HTTP 200 for the corrected behaviorism PDF, Fraser photo, root MP3, 2015 supplement, CogSci poster and /metapage/edmunds-et-al-2019/. See extra.json. These checks establish availability, not full content identity.

## Prioritised findings

### High — repair research and publication access

1. **68 broken internal targets.** Complete source-to-target evidence is in the table below and link-checks.csv. Many legacy /pubs/ pages use relative PDF links or publications.md links that resolve under the individual paper directory. Update these to the existing /assets/pdf/ files and /publications/; check each paper identity rather than blindly matching names.
2. **Wrong paper served for Longman et al. (2018).** On /publications/, “Transfer of learned category-response associations is modulated by instruction” points to /assets/pdf/edumunds2018.pdf. The opened PDF is Edmunds, Milton & Wills, “Due process in dual process”. Source: _publications/longman-et-al-2018.md:3. Candidate /assets/pdf/longman2017.pdf exists; verify its title before replacing the link.
3. **Research downloads have filename/path errors.** Examples: exe10prepocess.R versus existing exe10preprocess.R; exe6/exe5analysis.R versus existing exe6analysis.R; exe9/exe8data.csv versus existing exe9data.csv; syd2dataRECtxt versus existing syd2dataREC.txt. Confirm intended datasets, then correct the hrefs.
4. **Shared file-format help is missing.** /willslab-dau/formats.html is linked across many research-data units, and two pages also request local formats.html copies. Restore a shared format guide and normalise these links.

### Medium — current-page links and external destinations

5. **Placeholder values become links.** _publications/schlegelmilch-et-al-2024.md has osr: NA, producing /publications/NA. _quotes/jeffreys-1961.md has source: no_source, producing /quotes/no_source. Use a consistent absent-value convention and suppress links for blank/sentinel values in templates.
6. **Wrong asset paths on visible pages.** About me links to behaviorisms.pdf, but behaviorism.pdf exists. Co-authors requests fraser-milton.jpg, but the file is fraser_milton.jpg. Two metapages use assets/... without a leading slash, causing nested 404s; the root assets exist. Talks requests /assets/pdf/WillsCogSci2011.pdf, but the file is /assets/WillsCogSci2011.pdf. Correct the paths and recheck.
7. **26 external URLs consistently return 404.** These include university profiles, four OJEPN article PDFs, a DeepSim GitHub URL and older reference links. Verify replacement destinations with the relevant publisher/person; a GitHub 404 may represent private access rather than deletion. See the separate table; do not treat 403/999/challenge responses as evidence to delete a link.

### Medium — accessibility and mobile metadata

8. **Navigation dropdown IDs are duplicated.** _includes/nav.html:18 uses navbarDropdown inside a loop; all three dropdowns have the same ID and their menus reference it. Browser accessibility inspection labelled the expanded Outputs menu container “PEOPLE”. Generate a unique ID per dropdown and match aria-labelledby.
9. **86 inspected legacy HTML URLs lack both html lang and viewport metadata.** They are listed in pages.json. Add lang="en" and a responsive viewport declaration to the legacy pages/template and retest narrow layouts. No images missing an alt attribute were detected in the parsed seeds; adequacy of alt text was not assessed.

### Low — maintenance

10. The homepage describes a “menu icon” even on desktop, where the navigation is three text dropdowns. Prefer “navigation menu”. Dated posts with “currently” are clearly dated, but the 2022 peer-review policy may benefit from a present-day status note if it no longer applies; this is a review suggestion, not a verified factual error.
11. _layouts/base.html includes a sitewide third-party visitor counter and an HTTP attribution link. Review whether the counter is still wanted and use HTTPS for the attribution. An ordinary HTTP hyperlink is not itself mixed content; no blanket mixed-content failure is claimed.

## Confirmed internal 404 targets

All targets below returned 404 on both GET checks. Priority is high for research/paper access, medium for ancillary links/assets. Source paths are abbreviated to the site root; the CSV contains every source occurrence.

| Broken target path | Example source page | Source URL count | Recommended action |
|---|---|---:|---|
| `/assets/img/fraser-milton.jpg` | /coauthors/ | 1 | Use /assets/img/fraser_milton.jpg. |
| `/assets/pdf/Gregynog2004.pdf` | /talks/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/assets/pdf/WillsCogSci2011.pdf` | /talks/ | 1 | Use /assets/WillsCogSci2011.pdf. |
| `/assets/pdf/behaviorisms.pdf` | /aboutme/ | 1 | Use /assets/pdf/behaviorism.pdf. |
| `/metapage/edmunds-et-al-2019.md` | /pub-dualproc/ | 2 | Use /metapage/edmunds-et-al-2019/. |
| `/metapage/wills-et-al-2007/assets/mp3/Radio5liveAnitaAnand2007-07-02.mp3` | /metapage/wills-et-al-2007/ | 1 | Use root /assets/mp3/Radio5liveAnitaAnand2007-07-02.mp3. |
| `/metapage/wills-et-al-2015/assets/pdf/2015willsSup.pdf` | /metapage/wills-et-al-2015/ | 1 | Use root /assets/pdf/2015willsSup.pdf. |
| `/publications/NA` | /publications/ | 1 | Suppress missing repository value. |
| `/pubs/2008milton.pdf` | /willslab-dau/exe1/ | 2 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/2011wills.pdf` | /willslab-dau/exe2/ | 2 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/auto111/publications.md` | /pubs/auto111/ | 1 | Point to /publications/. |
| `/pubs/auto112/publications.md` | /pubs/auto112/ | 1 | Point to /publications/. |
| `/pubs/auto113/publications.md` | /pubs/auto113/ | 1 | Point to /publications/. |
| `/pubs/pu101/1997wills.pdf` | /pubs/pu101/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu102/1998jones.pdf` | /pubs/pu102/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu103/1998willsmclaren.pdf` | /pubs/pu103/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu103/wm98fig1.png` | /pubs/pu103/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu105/2002Wills.pdf` | /pubs/pu105/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu106/2002zwickel.pdf` | /pubs/pu106/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu107/2003welhamschnadtwills.pdf` | /pubs/pu107/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu108/2003lochmannwills.pdf` | /pubs/pu108/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu108/publications.md` | /pubs/pu108/ | 1 | Point to /publications/. |
| `/pubs/pu109/2004GotoWillsLea.pdf` | /pubs/pu109/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu109/publications.md` | /pubs/pu109/ | 1 | Point to /publications/. |
| `/pubs/pu110/2004willssuretmclaren.pdf` | /pubs/pu110/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu110/publications.md` | /pubs/pu110/ | 1 | Point to /publications/. |
| `/pubs/pu110/wsm04fig1a.pdf` | /pubs/pu110/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu110/wsm04fig1a.svg` | /pubs/pu110/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu111/2004miltonwills.pdf` | /pubs/pu111/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu111/publications.md` | /pubs/pu111/ | 1 | Point to /publications/. |
| `/pubs/pu112/2004bryantJonesWills.pdf` | /pubs/pu112/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu112/publications.md` | /pubs/pu112/ | 1 | Point to /publications/. |
| `/pubs/pu113/2005lepelley.pdf` | /pubs/pu113/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu113/publications.md` | /pubs/pu113/ | 1 | Point to /publications/. |
| `/pubs/pu114` | /publications/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu117/2005willsch6.pdf` | /pubs/pu117/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu117/publications.md` | /pubs/pu117/ | 1 | Point to /publications/. |
| `/pubs/pu119/2006leawillsryan.pdf` | /pubs/pu119/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu119/publications.md` | /pubs/pu119/ | 1 | Point to /publications/. |
| `/pubs/pu120/2006Willsetal.pdf` | /pubs/pu120/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu120/publications.md` | /pubs/pu120/ | 1 | Point to /publications/. |
| `/pubs/pu121/2006Willsetal.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/Daily+Mirror+03.07.08.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/FT+06.07.07.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/JOCN1905_C1.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/Metro+03.07.07.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/Radio5liveAnitaAnand2007-07-02.mp3` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/media/WillsSciAmMind.pdf` | /pubs/pu121/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu121/publications.md` | /pubs/pu121/ | 1 | Point to /publications/. |
| `/pubs/pu122/2006Willsetal.pdf` | /pubs/pu122/ | 1 | Find/verify intended asset or page; restore or replace link. |
| `/pubs/pu122/publications.md` | /pubs/pu122/ | 1 | Point to /publications/. |
| `/quotes/no_source` | /quotes/ | 1 | Suppress missing quote source. |
| `/willslab-dau/exe1/formats.html` | /willslab-dau/exe1/junk/index_old.html | 1 | Restore shared format guide; normalise link. |
| `/willslab-dau/exe1/junk/exe1code.txt` | /willslab-dau/exe1/junk/index_old.html | 1 | Remove junk/ prefix after checking existing file. |
| `/willslab-dau/exe1/junk/exe1data.txt` | /willslab-dau/exe1/junk/index_old.html | 1 | Remove junk/ prefix after checking existing file. |
| `/willslab-dau/exe1/junk/exe1stim.tbz` | /willslab-dau/exe1/junk/index_old.html | 1 | Remove junk/ prefix after checking existing file. |
| `/willslab-dau/exe10/eprime_convert_exe10.R` | /willslab-dau/exe10/ | 2 | Find/verify intended asset or page; restore or replace link. |
| `/willslab-dau/exe10/exe10prepocess.R` | /willslab-dau/exe10/ | 2 | Use exe10preprocess.R. |
| `/willslab-dau/exe10/formats.html` | /willslab-dau/exe10/scans/ | 2 | Restore shared format guide; normalise link. |
| `/willslab-dau/exe11/www.willslab.co.uk/exe11` | /willslab-dau/exe11/ | 2 | Use correct local data-unit URL or full https URL. |
| `/willslab-dau/exe13/www.willslab.co.uk/exe13` | /willslab-dau/exe13/ | 2 | Use correct local data-unit URL or full https URL. |
| `/willslab-dau/exe6/exe5analysis.R` | /willslab-dau/exe6/ | 2 | Verify and use exe6analysis.R. |
| `/willslab-dau/exe9/exe8data.csv` | /willslab-dau/exe9/ | 2 | Verify and use exe9data.csv. |
| `/willslab-dau/formats.html` | /willslab-dau/cam1/ | 70 | Restore shared format guide; normalise link. |
| `/willslab-dau/kulmaes1/kulmaes1phase1.sps` | /willslab-dau/kulmaes1/ | 2 | Find/verify intended asset or page; restore or replace link. |
| `/willslab-dau/pubs/2008milton.pdf` | /willslab-dau/exe1/junk/index_old.html | 1 | Find/verify intended asset or page; restore or replace link. |
| `/willslab-dau/syd2/logo.png` | /willslab-dau/syd2/ | 2 | Find/verify intended asset or page; restore or replace link. |
| `/willslab-dau/syd2/syd2dataRECtxt` | /willslab-dau/syd2/ | 2 | Use syd2dataREC.txt. |

## Persistent external 404s

All were rechecked; public availability was not established. Replace with a verified current destination, archive or accessible manuscript copy. Do not assume deletion where private access could explain the response.

| Target | Example source |
|---|---|
| http://hdl.handle.net/10026.1/16905 | /publications/ |
| http://seananderson.ca/2013/10/21/panel-letters.html | /willslab-dau/exe10/ |
| http://www.howtogeek.com/howto/31717/what-do-the-phrases-free-speech-vs.-free-beer-really-mean/ | /willslab-dau/kulmaes2/ |
| http://www.willslab.co.uk/catlearn.html | /willslab-dau/ply49/ |
| http://www.willslab.co.uk/plym10/bsci.R | /willslab-dau/exe10/ |
| https://brichandbook.readthedocs.io/en/latest/modelling.html | /bric-azure/ |
| https://core.ac.uk/download/pdf/193094737.pdf | /2021-05-18-cogsci-hard/ |
| https://fold.ai/our-team/ | /coauthors/ |
| https://github.com/ajwills72/deepsim | /deepsim/ |
| https://greeking.me/blog/greek-history-culture/item/57-10-most-important-archaeological-sites-of-greece | /naxos/ |
| https://scholar.google.co.uk/citations?user=PeAkz6oAAAAJ | /coauthors/ |
| https://towardsdatascience.com/reproducible-work-in-r-e7d160d5d198 | /deepsim-config/ |
| https://www.canterbury.ac.uk/science-engineering-and-social-sciences/psychology-and-life-sciences/psychology/staff/Profile.aspx?staff=549e189ce72fb760 | /coauthors/ |
| https://www.canterbury.ac.uk/science-engineering-and-social-sciences/psychology-and-life-sciences/staff/Profile.aspx?staff=e60942d39c138260 | /coauthors/ |
| https://www.computing.dcu.ie/~gjones/ | /coauthors/ |
| https://www.gluck.edu/mark_bio.html | /coauthors/ |
| https://www.linkedin.com/in/ben-hardwick-63b929120/?originalSubdomain=uk | /coauthors/ |
| https://www.liverpool.ac.uk/population-health/staff/rebecca-lawson/ | /coauthors/ |
| https://www.ojepn.com/images/2020/2020-8639.pdf | /publications/ |
| https://www.ojepn.com/images/2020/aa.pdf | /publications/ |
| https://www.ojepn.com/images/2021/2021-6623.pdf | /publications/ |
| https://www.ojepn.com/images/2022/2022-0404.pdf | /pub-attlearn/ |
| https://www.plymouth.ac.uk/staff/lenard-dome | /coauthors/ |
| https://www.plymouth.ac.uk/staff/tim-hollins-2 | /coauthors/ |
| https://www.secondhandbooksplymouth.co.uk/ | /2021-05-23-asimov/ |
| https://www2.le.ac.uk/departments/npb/people/akw12/index | /coauthors/ |

## Unresolved external responses

These are not confirmed broken links. Browser/login or a later check may resolve them. Status 202 is not itself failure, but does not establish that the intended content was served.

| Target | Recheck status | Example source | Evidence / action |
|---|---|---|---|
| http://doi.org/10.1002/hbm.24047 | 403 | /2021-11-29-frmi-ibre/ | Access restriction/challenge or non-final content; manually verify. |
| http://doi.org/10.1002/hbm.25729 | 403 | /2021-11-29-frmi-ibre/ | Access restriction/challenge or non-final content; manually verify. |
| http://fac.ppw.kuleuven.be/clep/affect4/ | 301 | /willslab-dau/kulmaes2/ | curl: (35) LibreSSL/3.3.6: error:1404B458:SSL routines:ST_CONNECT:tlsv1 unrecognized name |
| http://nurturesciencepub.org/ | 000 | /coauthors/ | curl: (6) Could not resolve host: nurturesciencepub.org |
| https://askubuntu.com/questions/1269493/ubuntu-server-20-04-1-lts-not-all-disk-space-was-allocated-during-installation | 403 | /cheat/linux-setup/ | Access restriction/challenge or non-final content; manually verify. |
| https://confluence.jaytaala.com/display/TKB/Mount+drive+in+linux+and+set+auto-mount+at+boot | 401 | /cheat/linux-setup/ | Access restriction/challenge or non-final content; manually verify. |
| https://direct.mit.edu/opmi/article/doi/10.1162/opmi_a_00208/131175 | 403 | /pub-objclass/ | Access restriction/challenge or non-final content; manually verify. |
| https://doi.org/10.1080/09658211.2019.1647247 | 403 | /publications/ | Access restriction/challenge or non-final content; manually verify. |
| https://elifesciences.org/articles/36395.pdf | 406 | /2021-11-29-frmi-ibre/ | Access restriction/challenge or non-final content; manually verify. |
| https://escholarship.org/uc/item/0kw671vv | 202 | /pub-attlearn/ | Access restriction/challenge or non-final content; manually verify. |
| https://escholarship.org/uc/item/5r98q3dr | 202 | /compute-request/ | Access restriction/challenge or non-final content; manually verify. |
| https://jkkweb.sitehost.iu.edu/articles/Kruschke2001JMP.pdf | 000 | /2021-11-29-frmi-ibre/ | curl: (60) SSL: no alternative certificate subject name matches target host name 'jkkweb.sitehost.iu.edu' More details here: https://curl.se/docs/sslcerts.html  curl failed to verify the legitimacy of the server and therefore could not establish a secure connection to it. To learn more about this situation and how to fix it, please visit the web page mentioned above. |
| https://keck.usc.edu/faculty-search/adam-matthew-leventhal/ | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://ore.exeter.ac.uk/repository/handle/10871/27115 | 202 | /publications/ | Access restriction/challenge or non-final content; manually verify. |
| https://people.sap.com/jan.zwickel | 000 | /coauthors/ | curl: (6) Could not resolve host: people.sap.com |
| https://people.uea.ac.uk/t_sambrook | 000 | /coauthors/ | curl: (6) Could not resolve host: people.uea.ac.uk |
| https://qz.com/1307091/the-inside-story-of-how-ai-got-good-enough-to-dominate-silicon-valley | 403 | /quotes/ | Access restriction/challenge or non-final content; manually verify. |
| https://rdcu.be/d56gS | 202 | /pub-dualproc/ | Access restriction/challenge or non-final content; manually verify. |
| https://uk.linkedin.com/in/mark-suret-25128b25 | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.city.ac.uk/about/people/academics/emmanuel-pothos | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.hostelbay.com/en/blog/top-10-historical-sites-you-should-not-miss-in-the-cyclades | 000 | /naxos/ | curl: (28) Failed to connect to www.hostelbay.com port 443 after 8006 ms: Timeout was reached |
| https://www.linkedin.com/in/angus-inkster-361315190/ | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/christina-meier-bb2b3a8a/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/dr-yvonne-hemmings-8593a111b/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/edward-copestake-b4b08494/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/elisa-maes-02b26536/?originalSubdomain=be | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/fayme-yeates-33a77a4a/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/garret-o-connell-9aa60722/?originalSubdomain=de | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/guido-de-filippo-0185213a/ | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/kathryn-carpenter-7456b6107/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/katie-blake96/ | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/kohzhisheng/?originalSubdomain=sg | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/pippa-bealing-9984411a6/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/rachel-baron-75bb1817/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.linkedin.com/in/stephen-oakeshott-b0437417/?originalSubdomain=uk | 999 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.mdpi.com/2076-328X/16/1/109 | 403 | /pub-hai/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.mdpi.com/2076-328X/16/3/437 | 403 | /pub-hai/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.patreon.com/astronomycast/posts | 403 | /2021-06-02-patreon/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/David-George-15 | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/Fraser-Milton | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/Jan-De-Houwer | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/Kazuhiro-Goto | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/Stuart-Spicer | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/profile/Tom-Beckers-2 | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/scientific-contributions/Frederick-Verbruggen-38674382 | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.researchgate.net/scientific-contributions/Lucy-J-Hopewell-25641277 | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.sciencedirect.com/science/article/pii/S0195666325005434?via%3Dihub | 403 | /publications/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.timeanddate.com/weather/greece/mykonos/climate | 403 | /naxos/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.ucl.ac.uk/pals/people/david-shanks | 403 | /coauthors/ | Access restriction/challenge or non-final content; manually verify. |
| https://www.visualcapitalist.com/cp/100-global-cities-by-quality-of-life-and-cost/ | 403 | /2026-09-10-numbeo/ | Access restriction/challenge or non-final content; manually verify. |

## Source-inventory candidates, not confirmed broken navigation

/docs/index.html and /tags.html returned 404. docs/ is excluded in _config.yml, and the working tag navigation uses /tags rather than /tags.html. These two source-derived candidates are excluded from the 68 internal broken-link count.

## Evidence and next steps

Evidence files alongside this report: link-checks.csv (every source/target occurrence), results.json (first response per requested URL), recheck.json (second checks), pages.json (HTML inventory and metadata), links.json, anchors.json and sitemap.xml. Network measurements are a snapshot, not guarantees of future availability.

Recommended repair order: current research/publication links and wrong-paper PDF; shared legacy path errors; missing files and external replacements; template sentinel handling and accessibility metadata. After changes, rerun the affected link checks and desktop/mobile spot-checks. The audit is complete within the stated coverage; repair work is outstanding.
