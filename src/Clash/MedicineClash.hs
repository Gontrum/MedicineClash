module Clash.MedicineClash (clash, daysWhenMedicineWasTaken, daysPerPrescription, Patient(Patient), Medicine(Medicine), Prescription(Prescription)) where

import Data.Function ((&))
import Data.Time (Day, fromGregorian, addDays)
import Data.List (groupBy,  intersect ) 

type Name = String
type DaysSupply = Integer
type DispenseDate = Day
data Prescription = Prescription DispenseDate DaysSupply
prescriptionForToday :: Prescription
prescriptionForToday = Prescription (fromGregorian 2020 9 29) 30

data Medicine = Medicine Name [Prescription]
getDays :: Medicine -> [DispenseDate]
getDays medicines = map (\(Prescription day _) -> day) (getPrescriptions medicines)
  where     getPrescriptions (Medicine name prescriptions) = prescriptions
addPrescription :: Medicine -> Prescription -> Medicine
addPrescription (Medicine name oldPrescriptions) prescription = Medicine name (prescription : oldPrescriptions)
getNames :: [Medicine] -> [Name]
getNames = map (\(Medicine name _) -> name)
mergeMedicineWithGivenNames :: [Medicine] -> [Name] -> [Medicine]
mergeMedicineWithGivenNames medicines names = map (\name -> (mergeToSingleMedicine (filterByName name medicines))) names
  where   filterByName :: Name -> [Medicine] -> [Medicine]
          filterByName name medicines = filter (\(Medicine medName _) -> name == medName) medicines
mergeToSingleMedicine :: [Medicine] -> Medicine
mergeToSingleMedicine (firstMed:medicines) = foldl mergeTwoMedicines firstMed medicines
mergeTwoMedicines :: Medicine -> Medicine -> Medicine
mergeTwoMedicines (Medicine name prescriptions) (Medicine _ prescriptions2) = Medicine name $ prescriptions ++ prescriptions2

data Patient = Patient [Medicine]
addMedicine :: Patient -> Medicine -> Patient
addMedicine (Patient oldMedicine) medicine = Patient $ medicine : oldMedicine

daysWhenMedicineWasTaken :: Medicine -> [DispenseDate]
daysWhenMedicineWasTaken (Medicine _ presciptions) = removeDuplicates $ concat $ map daysPerPrescription presciptions
daysPerPrescription :: Prescription -> [DispenseDate]
daysPerPrescription (Prescription _ 0) = []
daysPerPrescription (Prescription date numberOfDays) = date:(daysPerPrescription (Prescription (addDays 1 date) (numberOfDays - 1)))

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates = foldl (\acc curr -> if curr `elem` acc then acc else curr : acc) []

clash :: Patient -> [Name] -> [DispenseDate]
clash (Patient meds) names = foldl intersectAll daysOfFirstMedicine filteredMedicine
    where intersectAll :: [DispenseDate] -> Medicine -> [DispenseDate]
          intersectAll acc med = intersect acc $ daysWhenMedicineWasTaken med
          filteredMedicine = mergeMedicineWithGivenNames meds names
          daysOfFirstMedicine = daysWhenMedicineWasTaken $ firstMedicine filteredMedicine
          firstMedicine :: [Medicine] -> Medicine
          firstMedicine (first:_) = first