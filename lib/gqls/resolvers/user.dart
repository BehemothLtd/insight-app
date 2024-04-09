const String selfGeneralInfoGQL = """
query {
    SelfGeneralInfo {
        id
        email
        name
        fullName
        issuesCount
        projectsCount
        avatarUrl
        thisMonthWorkingHours {
            hours
            percentCompareToLastMonth
            upFromLastMonth
            timeGraphOnProjects {
                labels
                series
            }
        }
    }
}
""";
