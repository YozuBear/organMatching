% Section A: Create a list of matching kidneys to patients based on blood type.
% Blood type must match.
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

% blood_type_match(D,R) is true when D, the blood type of the donor, can be donated or matched with R,
%   the blood type of the recipient.

% The same blood type always match.
% blood_type_match(A,A):- blood_type(A).  % to avoid overlapping results
blood_type_match(a,a).
blood_type_match(b,b).

% Recipient with blood type AB is universal recipient.
blood_type_match(D,ab):- blood_type(D).

% Donor with blood type O is universal donor.
blood_type_match(o, R):- blood_type(R).


% Test cases for blood_type_match(D,R).
% Return true for same D and R blood types:
% ?- blood_type_match(a,a).
% ?- blood_type_match(b,b).
% ?- blood_type_match(o,o).
% ?- blood_type_match(ab,ab).

% Return true when R blood type is ab and D blood type is any other blood type.
% ?- blood_type_match(a,ab).
% ?- blood_type_match(b,ab).
% ?- blood_type_match(o,ab).

% Return false when D blood type is ab but R blood type is not ab.
% ?- blood_type_match(ab,a).
% ?- blood_type_match(ab,b).
% ?- blood_type_match(ab,c).

% Return true when D blood type is o and R blood type is any other blood type.
% ?- blood_type_match(o,a).
% ?- blood_type_match(o,b).
% ?- blood_type_match(o,ab).

% Return false when R blood type is o but D blood type is not o.
% ?- blood_type_match(a,o).
% ?- blood_type_match(b,o).
% ?- blood_type_match(ab,o).



% Given a recipient ID, return list of compatible kidney IDs based on blood type.
% matching_blood_type_ID(RecipientID, KidneyID) is true when the blood type of the recipient, identified by a
%   unique RecipientID, matches the blood type of a kidney identified by the KidneyID.

matching_blood_type_ID(RecipientID, KidneyID):- 
	prop(RecipientID,recipient_blood_type, R),
	prop(KidneyID, donor_blood_type, D), 
	blood_type_match(D,R).


% Sample test cases for matching_blood_type_ID(RecipientID, KidneyID).
% Return true when the recipient blood type matches the blood type of the donor kidney.
% ?- matching_blood_type_ID(recipient_2, kidney_4).
% ?- matching_blood_type_ID(recipient_2, kidney_3).

% Return false when the recipient blood type and the blood type of the donor kidney do not match.
% ?- matching_blood_type_ID(recipient_1, kidney_1).
% ?- matching_blood_type_ID(recipient_2, kidney_1).




% Section B: Create the ranking of kidneys for each recipient.
% The kidneys from Section A are used. (The donor kidneys which match the blood type of the recipient).

% Given a recipient ID, output list of kidneys that are compatible with
% the recipient, in descending order of compatibility.
sort_pairs(RecipientID, KidneyList):- 
	findall(K, kidney_score(RecipientID, K), L),
	rank(L, KidneyList).

% In - List of pairs where the pair-key is the score of kidney for the recipient
%      pair-value is the kidney ID
% KeyList - List of kidney IDs in descending order of kidney score.
% Ranks the kidneys according to score, then produce a ranked list without the score.
rank(In, RankedList):-
    sort(0, @>=, In, Out),
    pairList_to_KeyList(Out, RankedList).


% extract just the values of list.
% pairList_to_KeyList(PairList, List).
% PairList - List of pairs.
% List - same list as PairList in same order, with the keys taken out.
pairList_to_KeyList([], []).
pairList_to_KeyList([_-A|T], [A|L]):- pairList_to_KeyList(T, L).

% Calculate the score of compatible kidney to the recipient
% Create a pair of score of kidney as key, and kidney ID as value.
kidney_score(RecipientID, Score-KidneyID):- 
	matching_blood_type_ID(RecipientID, KidneyID),
	kidney_score(RecipientID, KidneyID, Score).

% Add up the score to rank kidneys for each recipient.
kidney_score(RecipientID, KidneyID, S):- 
	hlaMatch_a1(RecipientID, KidneyID, P1),
	hlaMatch_a2(RecipientID, KidneyID, P2),
	hlaMatch_b1(RecipientID, KidneyID, P3),
	hlaMatch_b2(RecipientID, KidneyID, P4),
	hlaMatch_dr1(RecipientID, KidneyID, P5),
	hlaMatch_dr2(RecipientID, KidneyID, P6),
	same_city_match(RecipientID, KidneyID, P7),
	living_donor(KidneyID, P8),
	S is P1+P2+P3+P4+P5+P6+P7+P8.

% References for HLA matching:
% http://www.ucdmc.ucdavis.edu/transplant/learnabout/learn_hla_type_match.html
% https://bethematch.org/patients-and-families/before-transplant/find-a-donor/hla-matching/
% DR antigens: https://en.wikipedia.org/wiki/HLA-DR

% HLA (human leukocyte antigens)Tissue typing: 
% High antigen matching improves the chances for a successful transplant 
% by helping donor cells engraft (make new blood cells) and reduce the risks of immune cells from 
% the donated organ cells (the graft) attack the recipient’s cells.
% A, B, and DR antigens are the most relevant for renal transplant.
% There are 78 types of DR antigens, but we will use the common 28 antigens here for simplicity.
% There are more than 2000 known alleles for type A antigens, but for simplicity, we will use use 100 for both A and B.

% Every person has two A, two B, and two DR antigens inheritted from the parents.
% Each match of antigen with donor (+1 point)
% hlaMatch(RecipientID, KidneyID, PointsAwarded)

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



% Section C: Rank the recipients based on recipient's priority score points.
% RankedRecipientsIDList is the RecipientsIDList sorted according to each recipient's priority score.
% rank_recipients(RecipientsIDList, RankedRecipientsIDList).
rank_recipients(K, RankedList):- 
	scoreRecipient(K, S),
	rank(S, RankedList).


% Create a recipient list where each recipient is scored based on the recipient's priority.
% scoreRecipient(RecipientsIDList, ScoreRecipientList).
scoreRecipient([], []).
scoreRecipient([H|T], [S-H|L]):-
	recipient_score(H, S),
	scoreRecipient(T, L).


% Calculate the recipient's priority score based on the rubrics described below (age, once_a_donor, and 
%   PRA percentage).
% RecipientID - the ID of recipient
% S - the priority score of the given recipient
recipient_score(RecipientID, S):- 
	pediatric_recipient(RecipientID, P1),
	once_a_donor(RecipientID, P2),
	pra_match(RecipientID, P3),
	S is P1+P2+P3.

% Sample test queries for recipient_score:
%Expected: recipient_30 is 1 year old, so that's +4 points for being a pediatric patient, is never once a 
%   a donor, so that's +0 points, and has a PRA percentage of 26, so that's +1 point; in total, X = 5.
% ?- recipient_score(recipient_30, X).


% Following are rubrics used to calculate recipients' priority score.


% Children under 5 are given priority (+4 points)
% Patients between age of 5~17 given priority (+2 points)
% Patients older than 17 do not gain priority points based on age.

pediatric_recipient(RecipientID, 4):- 
	prop(RecipientID, recipient_age, Age), 
	Age < 5.
pediatric_recipient(RecipientID, 2):- 
	prop(RecipientID, recipient_age, Age), 
	Age > 4, 
	Age < 18.
pediatric_recipient(RecipientID, 0):- 
	prop(RecipientID, recipient_age, Age), 
	Age > 17.

% Sample test queries for pediatric_recipient:
% Expected: recipient_30 is only 1 year old so X = 4.
% ?- pediatric_recipient(recipient_30, X).
% Expected: recipient_9 is age 15 so X = 2.
% ?- pediatric_recipient(recipient_9, X).
% Expected: recipient_13 is age 32 so X = 0.
% ?- pediatric_recipient(recipient_13, X).



% Recipients who were once a donor are given priority (+6 points), while recipients who were never a
%   donor do not gain any priority points.
once_a_donor(RecipientID, 6):- 
	prop(RecipientID, recipient_once_a_donor, 1).
once_a_donor(RecipientID, 0):- 
	prop(RecipientID, recipient_once_a_donor, 0).


% Sample test queries for once_a_donor:
% Expected: recipient_19 was once a donor so X = 6.
% ?- once_a_donor(recipient_19, X).
% Expected: recipient_30 was not a donor so X = 0.
% ?- once_a_donor(recipient_30, X).





% Reference: https://en.wikipedia.org/wiki/Panel_reactive_antibody
% Panel reactive antibody (PRA): 
% An immunological test that estimates the percentage of donors with whom a particular recipient would be incompatible.
% A high PRA means that the recipient's immune system is likely going to reject most donor organs.
% The PRA score is between 0% and 99%. 
% 0% ~ 10% (+2 points)
% 11% ~ 30% (+1 points)
% 31% ~ 60% (0 point)
% 61% ~ 99% (-1 point)
% pra_match(RecipientID, Points): calculate points awarded to the recipient
% based on pra score
%       2 points for PRA percentage < 11%
%       1 point for PRA percentage from 11% to 30%
%       0 points for PRA percentage from 31% to 60%
%       -1 points for PRA percentage from 61% to 99%

pra_match(RecipientID, 2):- 
	prop(RecipientID, recipient_PRA_percentage, PRA), 
	PRA<11.
pra_match(RecipientID, 1):- 
	prop(RecipientID, recipient_PRA_percentage, PRA), 
	PRA>10, 
	PRA<31.
pra_match(RecipientID, 0):- 
	prop(RecipientID, recipient_PRA_percentage, PRA), 
	PRA>30, 
	PRA<61.
pra_match(RecipientID, -1):- 
	prop(RecipientID, recipient_PRA_percentage, PRA), 
	PRA>60, 
	PRA<100.


% Sample test queries for pra_match:
% Expected: recipient_30 has recipient_PRA_percentage of 26, so he should get 1 point.
% ?- pra_match(recipient_30, X).
% Expected: recipient_16 has recipient_PRA_percentage of 90, so he should get -1 point.
% ?- pra_match(recipient_16, X).



% Section D: match recipients to kidneys based on highest ranking of section B and C.

% Match recipients and kidneys in the database, output is a pair list
% in the form of recipientID-kidneyID
match(OutputPairList):-
	findall(ID, recipient(ID), R),
	rank_recipients(R,Ranked),
	findall(E, kidney(E), L),
	once(match(Ranked, L ,OutputPairList)).



% Test query:
% ?- match(X).
% Note: output list may be too long so Prolog may not show the whole list. So run the following two below:
% (Query returns a pair list that matches a kidney with its highest ranked matched recipient based on
%   the whole test data; expected output should match the answer in expected matching output.txt)
%
% ?- set_prolog_flag(answer_write_options,[max_depth(0)]).
% ?- match(X).



% Helper functions for match(OutputPairList) below:

% match(RankedRecipientIDList, ListOfAvailableKidneys, matchedPairList).
% RankedRecipientIDList - a list containing all recipient IDs. It's ranked
% 					      in descending order, with highest priority recipient
%                         as its head.
% ListOfAvailableKidneys - IDs of all the kidneys from database.
% matchedPairList - the returned list of pairs of matched recipientID-kidneyID
match([], _, []).
match(_, [], []).
match([H|T], R, L):- 
	sort_pairs(H, P),
	find_kidney(P, R, K),
	member(K, R),
	delete1(K, R, R1),
	match(T, R1, L1),
	append([H-K], L1, L).
match([H|T], R, L):- 
	sort_pairs(H, P),
	find_kidney(P, R, K),
	\+ member(K, R),
	match(T, R, L).

% find_kidney(ListOfRankedWantedKidneys, ListOfAvailableKidneys, FoundKidney).
% FoundKidney - return the highest ranked kidney from ListOfRankedWantedKidneys
% that is a member of ListOfAvailableKidneys.
find_kidney([], _, null).
find_kidney(_, [], null).
find_kidney([H|_], R, H):- 
	member(H, R).
find_kidney([H|L], R, K):- 
	\+ member(H, R),
	find_kidney(L, R, K).


% prolog default library doesn't work, using following delete instead.
% http://eclipseclp.org/doc/bips/lib/lists/delete-3.html
% delete1(A,B,C) where listC is listB - elementA.
delete1(A, [A|B], B).
delete1(A, [B, C|D], [B|E]) :-
	delete1(A, [C|D], E).
