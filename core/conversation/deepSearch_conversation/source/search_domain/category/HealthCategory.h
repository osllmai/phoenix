#ifndef HEALTHCATEGORY_H
#define HEALTHCATEGORY_H
enum class HealthCategory {

    // General Medicine
    GeneralMedicine,
    InternalMedicine,
    FamilyMedicine,
    ClinicalMedicine,
    PrimaryCare,

    // Specialized Fields
    Cardiology,
    Neurology,
    Oncology,
    Gastroenterology,
    Pulmonology,
    Endocrinology,
    Dermatology,
    Orthopedics,
    Pediatrics,
    Geriatrics,
    Psychiatry,
    ObstetricsAndGynecology,
    Surgery,
    EmergencyMedicine,
    Anesthesiology,
    Radiology,
    Pathology,
    Ophthalmology,
    ENT, // Ear, Nose, Throat

    // Public Health & Epidemiology
    PublicHealth,
    Epidemiology,
    InfectiousDiseases,
    Vaccination,
    GlobalHealth,
    HealthPolicy,
    CommunityHealth,

    // Nutrition & Lifestyle
    Nutrition,
    DietAndWeightManagement,
    PhysicalFitness,
    ExerciseScience,
    SportsMedicine,
    Wellness,
    MentalWellbeing,
    StressManagement,
    SleepMedicine,

    // Psychology & Behavioral Health
    Psychology,
    ClinicalPsychology,
    Counseling,
    CognitiveBehavioralTherapy,
    MentalHealthAwareness,
    AddictionMedicine,
    SubstanceAbuse,

    // Medical Research & Technology
    MedicalResearch,
    Biotechnology,
    Pharmacology,
    DrugDevelopment,
    MedicalImaging,
    MedicalDevices,
    Telemedicine,
    DigitalHealth,

    // Diseases & Conditions
    ChronicDiseases,
    InfectiousDiseasesCategory,  // distinction for classification
    RareDiseases,
    AutoimmuneDiseases,
    GeneticDisorders,
    NeurologicalDisorders,
    CardiovascularDiseases,
    Cancer,

    // Others
    AlternativeMedicine,
    ComplementaryTherapy,
    PreventiveMedicine,
    HealthEducation
};

#endif // HEALTHCATEGORY_H
