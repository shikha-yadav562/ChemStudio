
// correct_answers.dart
/// Stores all correct answers by table name and question ID
const Map<String, Map<int, String>> correctAnswers = {
  // --------------------------
  // Salt A Preliminary Test
  'SaltA_PreliminaryTest': {
    1: 'Cu2+',
    2: 'Crystalline',
  },

  // Salt A Dry Test
  'SaltA_DryTest': {
    1: 'Cu2+',
    2: 'NH4+ Present',
    3: 'Cu2+ may be present',
  },



  // Salt B Preliminary Tests
  'SaltB_PreliminaryTest': {
    1: 'Pb2+',
    2: 'Crystalline',
  },

  // Salt B Dry Tests
  'SaltB_DryTest': {
    1: 'NH4+ Present',
    2: 'Pb2+ may be present',
    3: 'Pb2+ may Be present',
  },


   // Salt C Preliminary Tests
  'SaltC_PreliminaryTest': {
    1: 'Fe3⁺ may be present',
    2: 'Crystalline',
  },

  // Salt C Dry Tests
  'SaltC_DryTest': {
    1: 'Fe3+',
    2: 'NH4+ Absent',
    3: 'Ba2+ may be present',
  },


  // Salt D Preliminary Tests
  'SaltD_PreliminaryTest': {
    1: 'Ni2+',
    2: 'Crystalline',
  },

  // Salt D Dry Tests
  'SaltD_DryTest': {
    1: 'Cu2+',
    2: 'NH4+ Absent',
    3: 'Cu2+ may be present',
  },
  // -------------------------------
  // Wet Tests
 /* 'SaltA_WetTest': {
    1: 'Positive',
    2: 'Negative',
  },
  'SaltB_WetTest': {
    1: 'Positive',
    2: 'Positive',
  },*/
  'SaltC_WetTest': {
    1: 'Negative',
    2: 'Positive',
  },
 /* 'SaltD_WetTest': {
    1: 'Positive',
    2: 'Negative',
  },*/
};
