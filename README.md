# Kidney Matching
Authors: Yu Ju Liang, Trisha Huang.

## What is the problem?
Each year, many patients are put on the waitlist for kidney transplants. To find a matching kidney for each patient, we must consider blood type, cell antigen type (also known as human leukocyte antigen, abbreviated as HLA), and whether the donor kidney and the recipient are in the same city. These factors are weighted differently due to the nature of kidney transplant. For example, the kidney donor’s blood type must match with that of the recipient’s; therefore, it has higher priority than the location of the kidney and patient.

Kidney Matching finds a list of matching kidneys from the database for a patient, then ranks them based on the criteria listed above. If the core criteria is not matched (i.e. blood type), then rather than having a low rank in the matching list, the kidney will not be on the patient's list.

#### Data
- Donor kidney attributes: ID, city, blood type, HLA_A1, HLA_A2, HLA_B1, HLA_B2, HLA_DR1, HLA_DR2, living donor
- Recipient attributes: ID, city, blood type, age, HLA_A1, HLA_A2, HLA_B1, HLA_B2, HLA_DR1, HLA_DR2, once a donor, PRA percentage
- Sample sizes: 10 kidneys, 30 patients (using triple to store). Data generated by Java’s random number generator, with weighted scheme based on likelihood for blood type, age, city, and PRA percentage.

#### References
- Real-life donor matching system: https://optn.transplant.hrsa.gov/learn/about-transplantation/donor-matching-system/
- Kidney blood matching: http://www.ucdmc.ucdavis.edu/transplant/livingdonation/donor_compatible.html
- Kidney tissue typing / HLA matching: http://www.ucdmc.ucdavis.edu/transplant/learnabout/learn_hla_type_match.html
- Matching rubric: https://paireddonation.org/about-us/algorithm/

## What is the something extra?
Not only does Kidney Matching find a list of suitable kidneys for each recipient, it also ranks them based on a weighted scheme. It then assigns kidneys to a list of recipients based on their highest ranking. The recipients are also ranked based on their age, whether they were once a donor, and PRA percentage. This ranking is used in matching the donor kidneys to recipients, resolving conflicts where two or more recipient have the same highest ranking kidney.

## What did we learn from doing this?
Prolog is very suitable for solving matching problems. Logic programming is excellent at setting the matching rules by defining relations and other criteria such as calculating the weighted scheme specified in the problem domain.

At first, we considered including more than one organ type in the matching problem. For example, other organs that can be donated for transplants include heart, lungs, livers, pancreas, and the intestines. However, we found that there are many criteria to consider for matching just one kidney type to a recipient. While blood type and HLA are the core criteria for matching all donor organs to recipients, different organs have additional criteria to consider. For example, a lung transplant requires that the body size of the donor and the recipient must be similar so that the lobe of lung can fit inside the chest cavity of the recipient (reference: https://my.clevelandclinic.org/health/articles/lung-transplant-finding-an-kidney-donor).

Given the timeframe for this project, we decided to reduce the scope of the problem to focus on kidney transplants. However, we believe that it is feasible to use logic programming to build on the project and expand the scope of the problem to consider additional criteria for other organ transplants.

## Files
- test_data.pl: the kidney and recipient data.
- OrganMatching.pl: the main prolog program. (Must both test_data and OrganMatching.pl together).
- Kidney Matching Database.xlsx: the test data in excel format (more readable form).
- expected matching output: the text file of expected output for running the entire test_data
