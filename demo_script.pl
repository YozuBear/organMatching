% Section A. Compatible blood type

% 1.
% blood_type_match(Donor,Recipient)
blood_type_match(a, X).

% 2.
% Given a recipient ID, return list of compatible kidney IDs based on blood type.
% matching_blood_type_ID(RecipientID, KidneyID)
matching_blood_type_ID(recipient_7, KidneyID).

% Section B. Ranking kidneys for each recipient.
% 3.
% Each match of antigen with donor (+1 point)
hlaMatch_a1(recipient_7, kidney_2, HLA1Point).
hlaMatch_a1(recipient_14, kidney_4, HLA1Point).

% 4. 
% If the recipient and donor are in the same city, +3 points.
same_city_match(recipient_7, kidney_2, CityPoint).
prop(recipient_7, recipient_city, A).
prop(kidney_2, donor_city, B).

% 5.
% Living donor? (+2 points)
living_donor(kidney_2, LivingDonorPoint).

% 6. 
% Kidney Score of kidney_2 for recipient_7
kidney_score(recipient_7, kidney_2, S).

% 7. 
% Calculate the score of compatible kidney to the recipient
% Create a pair of score of kidney as key, and kidney ID as value.
kidney_score(recipient_7, K).

% 8.
% Given a recipient ID, output list of kidneys that are compatible with
% the recipient, in descending order of compatibility.
sort_pairs(recipient_7, Sorted).



% Test Queries for Section C: Ranking the recipients based on their priority score 

% Rubric for calculating priority score:

% 1.
% Priority points given to recipients who are pediatric patients:
% ?- pediatric_recipient(recipient_7, X).

% 2.
% Priority points given to recipients who were once a donor:
% ?- once_a_donor(recipient_7, X).

% 3.
% Priority points given to a recipient's PRA percentage:
% ?- pra_match(recipient_7, X).

% 4.
% Based on the three criteria above, calculate the total priority score for a given recipient:
% ?- recipient_score(recipient_7, X).

% 5.
% Get list of all recipients in the dataset:
% ?- set_prolog_flag(answer_write_options,[max_depth(0)]). 
% ?- findall(ID, recipient(ID), R).
% R = RecipientsIDList 
% R = [recipient_1,recipient_2,recipient_3,recipient_4,recipient_5,recipient_6,recipient_7,recipient_8,recipient_9,recipient_10,recipient_11,recipient_12,recipient_13,recipient_14,recipient_15,recipient_16,recipient_17,recipient_18,recipient_19,recipient_20,recipient_21,recipient_22,recipient_23,recipient_24,recipient_25,recipient_26,recipient_27,recipient_28,recipient_29,recipient_30].

% Score each recipient in the test data.
% ?- scoreRecipient([recipient_1,recipient_2,recipient_3,recipient_4,recipient_5,recipient_6,recipient_7,recipient_8,recipient_9,recipient_10,recipient_11,recipient_12,recipient_13,recipient_14,recipient_15,recipient_16,recipient_17,recipient_18,recipient_19,recipient_20,recipient_21,recipient_22,recipient_23,recipient_24,recipient_25,recipient_26,recipient_27,recipient_28,recipient_29,recipient_30], X).

% X = recipient list with score in front of each recipient 
% X = [0-recipient_1,0-recipient_2,2-recipient_3,7-recipient_4,1-recipient_5,2-recipient_6,1-recipient_7,1-recipient_8,1-recipient_9,-1-recipient_10,-1-recipient_11,4-recipient_12,-1-recipient_13,6-recipient_14,3-recipient_15,1-recipient_16,-1-recipient_17,-1-recipient_18,8-recipient_19,2-recipient_20,0-recipient_21,1-recipient_22,3-recipient_23,1-recipient_24,1-recipient_25,1-recipient_26,5-recipient_27,1-recipient_28,2-recipient_29,5-recipient_30].

% 6.
% Finally, sort the scored recipient list in descending order:
% ?- rank_recipients([recipient_1,recipient_2,recipient_3,recipient_4,recipient_5,recipient_6,recipient_7,recipient_8,recipient_9,recipient_10,recipient_11,recipient_12,recipient_13,recipient_14,recipient_15,recipient_16,recipient_17,recipient_18,recipient_19,recipient_20,recipient_21,recipient_22,recipient_23,recipient_24,recipient_25,recipient_26,recipient_27,recipient_28,recipient_29,recipient_30], X).

% X = the sorted ranked list
% X = [recipient_19,recipient_4,recipient_14,recipient_30,recipient_27,recipient_12,recipient_23,recipient_15,recipient_6,recipient_3,recipient_29,recipient_20,recipient_9,recipient_8,recipient_7,recipient_5,recipient_28,recipient_26,recipient_25,recipient_24,recipient_22,recipient_16,recipient_21,recipient_2,recipient_1,recipient_18,recipient_17,recipient_13,recipient_11,recipient_10].



% Test Queries for Section D: Matching the recipients to kidneys based on the rankings of sections B and C.

% List of available kidneys: [kidney_1,kidney_2,kidney_3,kidney_4,kidney_5,kidney_6,kidney_7,kidney_8,kidney_9,kidney_10].

% 1.
% Helper function match(RankedRecipientIDList, ListOfAvailableKidneys, matchedPairList).
% ?- match([recipient_19,recipient_4,recipient_14,recipient_30,recipient_27,recipient_12,recipient_23,recipient_15,recipient_6,recipient_3,recipient_29,recipient_20,recipient_9,recipient_8,recipient_7,recipient_5,recipient_28,recipient_26,recipient_25,recipient_24,recipient_22,recipient_16,recipient_21,recipient_2,recipient_1,recipient_18,recipient_17,recipient_13,recipient_11,recipient_10], [kidney_1,kidney_2,kidney_3,kidney_4,kidney_5,kidney_6,kidney_7,kidney_8,kidney_9,kidney_10] , X).

% X = [recipient_19-kidney_6,recipient_4-kidney_10,recipient_14-kidney_3,recipient_27-kidney_7,recipient_12-kidney_1,recipient_15-kidney_9,recipient_29-kidney_5,recipient_20-kidney_4,recipient_7-kidney_2,recipient_5-kidney_8].

% It gives the final answer - the final matching between each kidney and its highest ranked recipient in the test data.

% 2.
% The main function match(OutputPairList) is convenient because to make the query on the final matching list,
%   you just need to query match(X).

% ?- match(X).


