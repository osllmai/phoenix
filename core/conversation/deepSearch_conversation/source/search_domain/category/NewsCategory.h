#ifndef NEWSCATEGORY_H
#define NEWSCATEGORY_H

enum class NewsCategory {

    // ===== General News =====
    GeneralNews,          // General news items, not specialized
    BreakingNews,         // Urgent news or real-time updates
    LiveUpdates,          // Live coverage of ongoing events
    Headlines,            // Key or top news headlines

    // ===== Politics & Governance =====
    Politics,             // Political news and developments
    Elections,            // Election-related news
    Government,           // Government policies and actions
    PublicPolicy,         // Public policy and legislation
    InternationalRelations, // Diplomatic and global political news
    Diplomacy,            // Diplomatic actions and negotiations
    ConflictsAndWars,     // Conflicts, wars, and military actions
    Sanctions,            // Economic or political sanctions
    NationalSecurity,     // Security-related news at national level

    // ===== Economy & Business News =====
    Economy,              // General economic news
    Markets,              // Stock markets, financial markets
    Finance,              // Financial news, banking, investment
    Banking,              // Banking sector news
    Inflation,            // Inflation-related news
    Employment,           // Job market and employment news
    Trade,                // International and domestic trade
    EnergyMarkets,        // Oil, gas, renewable energy markets
    RealEstate,           // Property market news

    // ===== Technology & Science News =====
    Technology,           // General tech news
    ArtificialIntelligence, // AI-related news
    CyberSecurity,        // Cybersecurity news
    DataPrivacy,          // Privacy and data protection news
    Space,                // Space exploration, astronomy
    Science,              // General scientific news
    ScientificDiscoveries, // Discoveries, breakthroughs
    Innovation,           // Innovations and new technologies

    // ===== Health & Medical News =====
    Health,               // General health news
    PublicHealth,         // Public health issues
    Pandemics,            // Pandemic-related updates
    Diseases,             // Disease outbreaks and news
    Vaccines,             // Vaccine news and developments
    MedicalResearch,      // Research findings in medicine
    HealthcareSystems,    // Hospitals, healthcare policies

    // ===== Environment & Climate News =====
    Environment,          // Environmental news
    ClimateChange,        // Climate-related news
    ExtremeWeather,       // Extreme weather events
    NaturalDisasters,     // Earthquakes, floods, hurricanes
    Sustainability,       // Sustainability and green initiatives
    Wildlife,             // Wildlife and biodiversity news

    // ===== Society & Culture =====
    Society,              // Social issues and trends
    SocialIssues,         // Specific social challenges
    HumanRights,          // Human rights-related news
    Education,            // Educational updates and news
    Religion,             // Religious news and developments
    Culture,              // Cultural events and trends
    Migration,            // Migration and refugee news

    // ===== Sports News =====
    Sports,               // General sports news
    Football,             // Football news
    Basketball,           // Basketball news
    Tennis,               // Tennis news
    OlympicSports,        // Olympic-related news
    Motorsports,          // Formula, rally, and other motor racing
    CombatSports,         // Boxing, MMA, martial arts
    Esports,              // Competitive gaming news
    Transfers,            // Player transfers and trades

    // ===== Entertainment & Media News =====
    Entertainment,        // General entertainment news
    Movies,               // Film news and updates
    TVSeries,             // TV series news
    Music,                // Music industry news
    Celebrities,          // Celebrity news and gossip
    Awards,               // Awards, prizes, ceremonies
    BoxOffice,            // Box office and commercial success
    StreamingPlatforms,   // News related to streaming services

    // ===== Regional & Geographic =====
    World,                // Global news
    Regional,             // Regional or country-specific news
    Local,                // City or local-level news

    // ===== Journalism Types =====
    Opinion,              // Opinion pieces and commentary
    Editorial,            // Editorial articles
    Analysis,             // Analytical journalism
    Investigation,        // Investigative journalism
    FactCheck,            // Fact-checking reports
    Interview,            // News interviews
    Report,               // General news reports

    // ===== Crisis & Emergency =====
    Emergencies,          // Emergency situations
    Accidents,            // Accidents and incidents
    Terrorism,            // Terrorist attacks or threats
    PublicSafety,         // Safety alerts and advisories

    // ===== Other =====
    Other                 // Uncategorized or miscellaneous news

};

#endif // NEWSCATEGORY_H
