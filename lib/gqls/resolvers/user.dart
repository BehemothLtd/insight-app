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

// TODO: add params to filter
const String selfAttendancesGQL = """
  query SelfAttendances {
    SelfAttendances(
      input: { perPage: null, page: null }
      query: { checkinAtLteq: null, checkinAtGteq: null }
    ) {
      collection {
        checkinAt
        checkoutAt
        createdAt
      }
      metadata {
        total
        perPage
        page
        pages
        count
        next
        prev
        from
        to
      }
    }
  }
""";

const String selfProfileGQL = """
query {
  SelfProfile {
    id
    email
    fullName
    name
    about
    avatarUrl
    address
    birthday
    gender
    phone
    slackId
  }
}
""";
