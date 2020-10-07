{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE TypeFamilies              #-}
import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine
import Data.Time (Day, fromGregorian)
import Clash.MedicineClash
    ( Patient(Patient),
      Medicine(Medicine),
      Prescription(Prescription),
      clash,
      daysPerPrescription )

b1 :: Diagram B
b1 = square 20 # lw 0.002

testPatient :: Patient
testPatient = Patient [Medicine "penicillin" [Prescription (fromGregorian 2020 1 1) 365]]
--test = clash testPatient ["penicillin"]
test = [firstDay testPatient,lastDay testPatient]
firstDay :: Patient -> Day
firstDay (Patient medicines) = minimum $ concat $ map daysPerPrescription (allPrescriptions medicines)
lastDay :: Patient -> Day
lastDay (Patient medicines) = maximum $ concat $ map daysPerPrescription (allPrescriptions medicines)

allPrescriptions :: [Medicine] -> [Prescription]
allPrescriptions medicines = concat $ map (\(Medicine _ prescriptions) -> prescriptions) medicines

greenCircle :: Diagram B
greenCircle = circle 1  # fc green
                        # lw veryThick
                        # lc purple
                        # dashingG [0.2, 0.05] 0
                        # showOrigin

blueCircle :: Diagram B
blueCircle = circle 2 # fc blue

--main = mainWith (pad 1.1 (greenCircle `atop` (blueCircle # translate (r2 (0, 1)))))

node :: Int -> Diagram B
node n = text (show n) # fontSizeL 0.2 # fc white 
        <> circle 0.2 # fc green # named n

textify :: Day -> Diagram B
textify toPrint = text (show toPrint) # fontSizeL 0.2 # fc black <> rect 1 0.5 # fc white

arrowOpts = with & gaps       .~ small
                 & headLength .~ local 0.15

tournament :: Int -> Diagram B
tournament n = atPoints (trailVertices $ regPoly n 1) (map node [1..n]) # applyAll [connectOutside' arrowOpts j k | j <- [1 .. n-1], k <- [j+1 .. n]]

--main = mainWith $ tournament 5
main = mainWith $  hcat (map textify test)
