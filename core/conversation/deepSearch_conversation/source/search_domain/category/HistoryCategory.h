#ifndef HISTORYCATEGORY_H
#define HISTORYCATEGORY_H

// Enum representing different categories and subfields of history
enum class HistoryCategory {

    Unknown, // Category for undefined or unspecified historical topics

    // ===== General History =====
    WorldHistory,       // Covers overall world history across all regions
    AncientHistory,     // History from the earliest civilizations up to classical antiquity
    MedievalHistory,    // Middle Ages, roughly 5th–15th centuries
    EarlyModernHistory, // 15th–18th centuries, Renaissance to Enlightenment
    ModernHistory,      // 18th–20th centuries, Industrial Revolution to early 1900s
    ContemporaryHistory,// 20th century to present

    // ===== Regional / National History =====
    HistoryOfAfrica,    // History specific to African continent
    HistoryOfAsia,      // History of Asian countries and civilizations
    HistoryOfEurope,    // History of European countries
    HistoryOfNorthAmerica, // History of North American nations
    HistoryOfSouthAmerica, // History of South American nations
    HistoryOfOceania,      // History of Australia, New Zealand, and Pacific islands
    HistoryOfMiddleEast,   // History of Middle Eastern countries
    HistoryOfIran,          // History specific to Iran
    HistoryOfUSA,           // History specific to United States
    HistoryOfChina,         // History specific to China
    HistoryOfIndia,         // History specific to India
    HistoryOfUK,            // History specific to United Kingdom

    // ===== Thematic History =====
    PoliticalHistory,      // History of governments, political systems, and ideologies
    MilitaryHistory,       // History of wars, battles, armies, and military strategies
    EconomicHistory,       // History of economies, trade, and financial systems
    SocialHistory,         // History of societies, daily life, and social structures
    CulturalHistory,       // History of customs, traditions, and cultural developments
    ReligiousHistory,      // History of religions, belief systems, and spiritual movements
    IntellectualHistory,   // History of ideas, philosophies, and intellectual movements
    HistoryOfScience,      // History of scientific discoveries and progress
    HistoryOfTechnology,   // History of technological inventions and innovations
    HistoryOfArt,          // History of painting, sculpture, architecture, etc.
    HistoryOfLiterature,   // History of written works, poetry, and literature

    // ===== Events & Periods =====
    Revolutions,           // Significant revolutions (e.g., French, Russian)
    Wars,                  // General wars not included in global conflicts
    Empires,               // Rise and fall of empires
    Colonization,          // Periods of colonial expansion
    IndependenceMovements, // Movements for national independence
    GlobalConflicts,       // Includes World War I, World War II, and other large-scale wars
    ColdWarEra,            // History of the Cold War (approx. 1947–1991)
    IndustrialRevolution,  // Industrialization period, 18th–19th centuries
    Renaissance,           // European Renaissance, 14th–17th centuries
    Enlightenment,         // Intellectual and philosophical movement in Europe, 17th–18th centuries
    MiddleAges,            // Also known as Medieval period

    // ===== Biographies / Historical Figures =====
    HistoricalFigures,     // General historical personalities
    LeadersAndKings,       // Monarchs and political leaders
    ScientistsAndInventors,// Notable scientists and inventors
    ArtistsAndWriters,     // Influential artists and literary figures
    Philosophers,          // Famous philosophers
    PoliticalLeaders,      // Statesmen, presidents, prime ministers
    Activists,             // Historical activists and reformers

    // ===== Miscellaneous / Others =====
    Miscellaneous          // Any history topic that doesn't fit above categories
};

#endif // HISTORYCATEGORY_H
