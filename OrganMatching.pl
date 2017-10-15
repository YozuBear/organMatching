% Section A: create a list of matching kidneys to patients based on blood type.
% Blood type must match
% Blood matching: http://www.ucdmc.ucdavis.edu/transplant/livingdonation/donor_compatible.html
% If your blood type is: 	You can donate to these blood types:
% 	TYPE O					TYPE O, A, B, AB
% 	TYPE A					TYPE A, AB
% 	TYPE B					TYPE B, AB
% 	TYPE AB					TYPE AB

% All blood types
blood_type(a).
blood_type(b).
blood_type(ab).
blood_type(o).

% blood_type_match(D,R).
% Where D is the blood type of donor, R is blood type of recipient.

% same blood type always match
% blood_type_match(A,A):- blood_type(A).  % to avoid overlapping results
blood_type_match(a,a).
blood_type_match(b,b).

% recipient with blood type AB is universal recipient
blood_type_match(D,ab):- blood_type(D).

% donor with blood type O is universal donor.
blood_type_match(o, R):- blood_type(R).

% Given a recipient (ID), return list of compatible kidney IDs based on blood type
% matching_blood_type_ID(RecipientID, KidneyID)
matching_blood_type_ID(RecipientID, KidneyID):- 
prop(RecipientID,recipient_blood_type, R),
prop(KidneyID, donor_blood_type, D), 
blood_type_match(D,R).


% Section B: Create the ranking of kidneys for each recipient.

% http://www.ucdmc.ucdavis.edu/transplant/learnabout/learn_hla_type_match.html
% https://bethematch.org/patients-and-families/before-transplant/find-a-donor/hla-matching/
% DR antigens: https://en.wikipedia.org/wiki/HLA-DR
% HLA (human leukocyte antigens)Tissue typing: 
% High antigen matching improves the chances for a successful transplant 
% by helping donor cells engraft (make new blood cells) and reduce the risks of immune cells from 
% the donated organ cells (the graft) attack the recipient’s cells.
% A, B, DR antigens are the most relevant for renal transplant
% There are 78 types of DR antigens, will use the common 28 antigens here for simplicity.
% There are more than 2000 known allels for type A antigens, for simplicity, use 100 for both A and B.

% Every person has two A, two B, and two DR antigens inheritted from the parents.
% Each match of antigen with donor (+1 point)
% hlaMatch(RecipientID, KidneyID, Points)

%findall(K, rank_kidney(recipient_8, K), L), keysort(L, Sorted).
rank_kidney(RecipientID, Score-KidneyID):- 
matching_blood_type_ID(RecipientID, KidneyID),
score(RecipientID, KidneyID, Score).

% Add up the score to rank kidneys for each recipient.
score(RecipientID, KidneyID, S):- 
hlaMatch_a1(RecipientID, KidneyID, P1),
hlaMatch_a2(RecipientID, KidneyID, P2),
hlaMatch_b1(RecipientID, KidneyID, P3),
hlaMatch_b2(RecipientID, KidneyID, P4),
hlaMatch_dr1(RecipientID, KidneyID, P5),
hlaMatch_dr2(RecipientID, KidneyID, P6),
same_city_match(RecipientID, KidneyID, P7),
living_donor(KidneyID, P8),
S is P1+P2+P3+P4+P5+P6+P7+P8.

hlaMatch_a1(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_A1, A),
prop(KidneyID, donor_HLA_A1, A).

hlaMatch_a1(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_A1, A),
prop(KidneyID, donor_HLA_A1, B),
dif(A,B).

hlaMatch_a2(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_A2, A),
prop(KidneyID, donor_HLA_A2, A).

hlaMatch_a2(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_A2, A),
prop(KidneyID, donor_HLA_A2, B),
dif(A,B).

hlaMatch_b1(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_B1, A),
prop(KidneyID, donor_HLA_B1, A).

hlaMatch_b1(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_B1, A),
prop(KidneyID, donor_HLA_B1, B),
dif(A,B).

hlaMatch_b2(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_B2, A),
prop(KidneyID, donor_HLA_B2, A).

hlaMatch_b2(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_B2, A),
prop(KidneyID, donor_HLA_B2, B),
dif(A,B).

hlaMatch_dr1(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_DR1, A),
prop(KidneyID, donor_HLA_DR1, A).

hlaMatch_dr1(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_DR1, A),
prop(KidneyID, donor_HLA_DR1, B),
dif(A,B).

hlaMatch_dr2(RecipientID, KidneyID, 1):- 
prop(RecipientID,recipient_HLA_DR2, A),
prop(KidneyID, donor_HLA_DR2, A).

hlaMatch_dr2(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_HLA_DR2, A),
prop(KidneyID, donor_HLA_DR2, B),
dif(A,B).

% Recipient and donor in same city (+3 points)
same_city_match(RecipientID, KidneyID, 3):- 
prop(RecipientID,recipient_city, A),
prop(KidneyID, donor_city, A).

same_city_match(RecipientID, KidneyID, 0):- 
prop(RecipientID,recipient_city, A),
prop(KidneyID, donor_city, B),
dif(A,B).

% Living donor? (+2 points)
% Transplant outcomes are generally better with kidneys from living donors than for kidneys from deceased donors. 
living_donor(KidneyID, 2):- 
prop(KidneyID, donor_live, 1).

living_donor(KidneyID, 0):- 
prop(KidneyID, donor_live, 0).

% Section C: Assigning kidneys to different recipients based on highest ranking of section A.

% Children under 5 are given priority (+4 points)
% Patients between age of 5~17 given priority (+2 points)


% recipients who were once a donor given priority (+6 points)


% https://en.wikipedia.org/wiki/Panel_reactive_antibody
% Panel reactive antibody (PRA): 
% An immunological test that estimates the percentage of donors with whom a particular recipient would be incompatible.
% A high PRA means that the recipient's immune system is likely going to reject most donor organs.
% The PRA score is between 0% and 99%. 



