# Airrecord integration tests against a live base

## Setup

1. Request access to [the live testing Base](https://airtable.com/app5gmfuvQnN1bIyR)
2. Clone this repo so that its directory is adjacent to `airrecord`, e.g:
    ```
    ~/code/airrecord
    ~/code/airrecord-integration
    ```
3. Create a `.env` file in the root of `airrecord-integration`, with your
    Airtable API key:
    ```
    AIRTABLE_API_KEY=your_key_here
    ```
4. Install dependencies with `bundle install`

5. Run the tests with `bundle exec rake`
