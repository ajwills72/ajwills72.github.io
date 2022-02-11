# Brief notes on setting up SONA <-> JATOS link

These notes cover getting our JATOS server (which runs the experiment) and our SONA server (which handles participant recruitment and credit awards) to talk to each other. This should be the last step, when you're sure the experiment works correctly on JATOS in all other respects.

To set up the SONA to JATOS and back to SONA links, you need to take the following four steps:

## 1. On SONA

- Set up study on SONA as an Online External Study

- Ensure "Automatic Credit Granting" is set to "no"

- Set study URL to a placeholder for now, you need something with `%SURVEY_CODE%` in it so SONA will give you a completion URL:

`http://psy.plymouth.ac.uk/publix/476/start?batchId=1&generalMultiple&sonaId=%SURVEY_CODE%`

- In Study Information, Website, Completion URLs (client side), get the link provided e.g.:

`https://uopsop.sona-systems.com/webstudy_credit.aspx?experiment_id=4272&credit_token=9409d39cb23c49f0a7265d0a59057bbb&survey_code=XXXX`

- Cut off the `XXXX` and keep a note, you'll need this later, e.g.

`https://uopsop.sona-systems.com/webstudy_credit.aspx?experiment_id=4272&credit_token=9409d39cb23c49f0a7265d0a59057bbb&survey_code=`

- Don't request approval for study yet!

## 2. On OpenSesame desktop app

- Right at the begining of the experiment add this inline code:

`vars.participant_URL_ID = jatos.urlQueryParameters.sonaId`

- Right at the end of the experiment, add this inline code:

`jatos.endStudyAndRedirect("completionURL" + vars.participant_URL_ID);`

where `completionURL` is replaced with what you kept earlier from SONA, e.g. 

`jatos.endStudyAndRedirect("https://uopsop.sona-systems.com/webstudy_credit.aspx?experiment_id=4272&credit_token=9409d39cb23c49f0a7265d0a59057bbb&survey_code=" + vars.participant_URL_ID);`



- Note that these additions will cause your script to crash if you now try to run it locally - the jatos library is only added to the ZIP files when the experiment is exported, see below.

- Go to Tools -> OS Web; make sure, "Possible subject numbers" is blank, and use "Export experiment as JATOS study".

## 3. On JATOS

- Upload study using the ZIP file you've just created

- Enable General Multiple Worker

- Get link for General Multiple Worker for this study. e.g.

`http://psy.plymouth.ac.uk/publix/476/start?batchId=543&generalMultiple`

## 4. Back on SONA

- Set Study URL as the URL just retrieved from JATOS, but with `&sonaId=%SURVEY_CODE%` appended (SONA will replace `%SURVEY_CODE%` with an actual number):

`http://psy.plymouth.ac.uk/publix/476/start?batchId=543&generalMultiple&sonaId=%SURVEY_CODE%`

- Now, request study approval.



