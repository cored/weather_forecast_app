**Overview:**
weather_forecast_app is a Ruby on Rails application designed to provide weather forecasts based on user-provided addresses. It utilizes various components such as ForecastRequestJob, Forecasts module, ForecastsController, and OpenWeatherMap API to fetch and display real-time weather forecast data.

**Setup:**

1. **Clone Repository:**
	 ```
	 git clone <repository-url>
	 ```

2. **Install Dependencies:**
	 ```
	 bundle install
	 ```

3. **Environment Variables:**
	 Ensure that the following environment variables are properly configured:
	 - `OPEN_WEATHER_API_KEY`: API key for OpenWeatherMap API.
	 - `CACHE_EXPIRES_IN`: Optional expiration time for forecast cache (default: 30 minutes).

**Sequence Diagrams:**

Below are the sequence diagrams illustrating the two main flows of the application:

1. **Forecast Request Flow:**

	 ```
	 Client              ForecastRequestJob              ForecastsController         OpenWeatherMap API
		 |                         |                               |                               |
		 |--- Request forecast --->|                               |                               |
		 |                         |                               |                               |
		 |                         |--- Initiate forecast job --->|                               |
		 |                         |                               |                               |
		 |                         |                               |--- Fetch forecast data ---->|
		 |                         |                               |                               |
		 |                         |                               |<--- Return forecast data ----|
		 |                         |                               |                               |
		 |                         |--- Broadcast forecast ----->|                               |
		 |                         |                               |                               |
		 |<-- Receive forecast -----|                               |                               |
	 ```

2. **Error Handling Flow:**

	 ```
	 Client              ForecastRequestJob              ForecastsController
		 |                         |                               |
		 |--- Request forecast --->|                               |
		 |                         |                               |
		 |                         |--- Initiate forecast job --->|
		 |                         |                               |
		 |                         |                               |--- Handle invalid address -->
		 |                         |                               |                               |
		 |                         |                               |--- Broadcast error -------->|
		 |                         |                               |                               |
		 |                         |<-- Receive error ------------|                               |
	 ```

**Decomposition of Objects:**

Objects within the weather_forecast_app are decomposed based on their responsibilities and functionalities. Each object is designed to handle a specific aspect of the application, promoting modularity and maintainability.

**Design Strategy:**

The design strategy of weather_forecast_app follows the principles of separation of concerns and domain-driven design. Data is separated from behavior, and related objects and behaviors are grouped under the same namespace to form a coherent domain model.

**Naming Conventions:**

In weather_forecast_app, naming conventions follow enterprise-scale production code standards, utilizing verbs for actions and nouns for data. This approach ensures clarity and consistency throughout the codebase, facilitating understanding and maintenance.

**Main Components:**

1. **ForecastRequestJob:**
	 - **Description:** Responsible for fetching weather forecasts based on the provided address.
	 - **Queue:** Default
	 - **Dependencies:** Turbo::StreamsChannel, Forecasts::Address, Forecasts module, Rails.cache
	 - **Error Handling:** Catches Forecasts::InvalidAddress errors and broadcasts error messages. Handles other exceptions during forecast retrieval.
	 - **Broadcasting:** Utilizes Turbo::StreamsChannel to broadcast forecast details or error messages to clients.

2. **Forecasts Module:**
	 - **Description:** Contains methods for fetching forecasts by address and handling address-related operations.
	 - **Components:**
		 - **by_address(address, store, weather_api):** Fetches forecasts by address using a specified weather API (default: OpenWeatherMap).
		 - **InvalidAddress:** Exception class for invalid address errors.
		 - **Address:** Struct for representing and formatting addresses.
		 - **InvalidForecast:** Exception class for invalid forecast errors.
		 - **Forecast:** Struct for representing forecast data.

3. **ForecastsController:**
	 - **Description:** Handles incoming requests for fetching weather forecasts.
	 - **Actions:**
		 - **create:** Initiates ForecastRequestJob for the provided address and renders forecast details or error messages using Turbo Streams.

4. **OpenWeatherMap:**
	 - **Description:** Wrapper for OpenWeatherMap API client.
	 - **Dependencies:** open-weather-ruby-client gem
	 - **Methods:**
		 - **forecast_by_address(address, api_key):** Retrieves weather forecast data for a given address using OpenWeatherMap API.
		 - **Response:** Struct for representing API response data.
