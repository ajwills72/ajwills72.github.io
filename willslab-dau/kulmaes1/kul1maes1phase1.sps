GLM R_15 R_16 R_17 R_18 R_19 R_20 R_21 R_22 R_23 R_24 R_25 R_26 R_27 R_28 R_29 R_30 R_31 R_32 R_33 
    R_34 R_35 R_36 R_37 R_38 R_39 R_40 R_41 U_15 U_16 U_17 U_18 U_19 U_20 U_21 U_22 U_23 U_24 U_25 U_26 
    U_27 U_28 U_29 U_30 U_31 U_32 U_33 U_34 U_35 U_36 U_37 U_38 U_39 U_40 U_41
  /WSFACTOR=Reinforcement 2 Polynomial Session 27 Polynomial 
  /METHOD=SSTYPE(3)
  /PRINT=DESCRIPTIVE ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Reinforcement Session Reinforcement*Session.

T-TEST PAIRS=R_15 R_16 R_17 R_18 R_19 R_20 R_21 R_22 R_23 R_24 R_25 R_26 R_27 R_28 R_29 R_30 R_31 
    R_32 R_33 R_34 R_35 R_36 R_37 R_38 R_39 R_40 R_41 WITH U_15 U_16 U_17 U_18 U_19 U_20 U_21 U_22 U_23 
    U_24 U_25 U_26 U_27 U_28 U_29 U_30 U_31 U_32 U_33 U_34 U_35 U_36 U_37 U_38 U_39 U_40 U_41 (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.
