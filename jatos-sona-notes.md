# Brief notes on setting up SONA <-> JATOS link

These notes cover getting our JATOS server (which runs the experiment) and our SONA server (which handles participant recruitment and credit awards) to talk to each other. This should be the last step, when you're sure the experiment works correctly on JATOS in all other respects.



To set up the SONA to JATOS and back to SONA links, you need to take the following steps:

**Note 1:** Variable names are case-sensitive, so make sure you us `sonaId` throughout, NOT SonaID, or SonaId, or...

**Note 2:** The credit is only granted when the participant is redirected to SONA. This means the OpenSesame experiment has to complete. So, make sure your instructions make this clear, by having your debrief screen end with something like "PRESS A KEY TO COLLECT YOUR PARTICIPATION POINTS". 

## 1. On OpenSesame desktop app

- Right at the begining of the experiment add this inline _javascript_ code, in the _prepare_ window (not the run window:

```
if (window.jatos && jatos.urlQueryParameters.sonaId) {
    console.log('Sona information is available')
    vars.sona_participant_id = jatos.urlQueryParameters.sonaId
} else {
    console.log('Sona information is not available (setting value to -1)')
    vars.sona_participant_id = -1
}
console.log('sona_participant_id = ' + vars.sona_participant_id)
```

- Go to Tools -> OS Web; make sure, "Possible subject numbers" is blank, and use "Export experiment as JATOS study".

## 2. On JATOS

- Upload study using the ZIP file you've just created

- Enable General Multiple Worker

- Get link for General Multiple Worker for this study. e.g.

`http://psy.plymouth.ac.uk/publix/476/start?batchId=543&generalMultiple`


## 3. On SONA

Do the following under "Change Study Information" on SONA:

- Set up study on SONA as an Online External Study

- Ensure "Automatic Credit Granting" is set to "no" 

- Set study URL to the link you got from JATOS, with `&sonaId=%SURVEY_CODE%` added, e.g. 

`http://psy.plymouth.ac.uk/publix/476/start?batchId=1&generalMultiple&sonaId=%SURVEY_CODE%`

- In Study Information, Website, Completion URLs (client side), get the link provided e.g.:

`https://uopsop.sona-systems.com/webstudy_credit.aspx?experiment_id=4272&credit_token=9409d39cb23c49f0a7265d0a59057bbb&survey_code=XXXX`

- Cut off the `XXXX` and replace with `[sonaId]`, e.g. 

`https://uopsop.sona-systems.com/webstudy_credit.aspx?experiment_id=4272&credit_token=9409d39cb23c49f0a7265d0a59057bbb&survey_code=[sonaId]`

## 4. Back on JATOS

- Go to the Properties page of your study, and insert the above link into the End Redirect URL.

## 5. Back on SONA

- Request study approval.



