### MedicineClash

Haskell implementation of the [Medicine Clash Kata](https://github.com/emilybache/KataMedicineClash)

### Run tests

You can run the tests with `cabal run`

---

__As a__ Health Insurer,

__I want__ to be able to search for patients who have a medicine clash,

__So that__ I can alert their doctors and get their prescriptions changed.

Health Insurance companies don't always get such good press, but in this case, they actually do have your best interests at heart. Some medicines interact in unfortunate ways when they get into your body at the same time, and your doctor isn't always alert enough to spot the clash when writing your prescriptions. Sometimes, medicine interactions are only identified years after the medicines become widely used, and your doctor might not be completely up to date. Your Health Insurer certainly wants you to stay healthy, so discovering a customers has a medicine clash and getting it corrected is good for business, and good for you!

For this Kata, you have a recently discovered medicine clash, and you want to look through a database of patient medicine and prescription records, to find if any need to be alerted to the problem. Create a "Patient" class, with a method "Clash" that takes as arguments a list of medicine names, and how many days before today to consider, (defaults to the last 90 days). It should return a collection of days on which all the medicines were being taken during this time.
