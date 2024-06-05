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

[[system design|Design]] is not only the concern of architects and artists, but also of programmers. By following the principles of simplicity and separation of concerns, we can achieve elegant and functional designs.

The application of two items can separate a system's architecture from its technical dependencies, such as databases and user interfaces, and create bridges between the application core and each technical domain. This separation of concerns ensures that changing the behavior of a system does not require a hunt through every part of such. Each component is made cohesive, and business rules are separated from technical details, leaving options open in a software system.

Encapsulation ensures that the behavior of an object can only be affected through its API, controlling how much a change to an object affects other parts of the system and hiding object information.

It also conceals how an object implements its functionality behind the abstraction of its API, ensuring that there are no unexpected dependencies between unrelated components.

> Combining APIs defines a higher-level abstraction that ignores lower-level details unrelated to the task.

Working at higher levels of abstraction reduces cognitive complexity, making it more effective than manipulating variables and control flows. Components are only developed when a higher-level abstraction exists for people to discuss and improve.

> The goal is to define the API that describes the relationship between domain components and the outside world.

**Naming Conventions:**

Readers shouldn’t have to mentally translate your names into other names they already know.  This problem generally arises from a choice to use neither problem domain terms nor solution domain terms.

If you can’t pronounce it, you can’t discuss it without sounding like an idiot.  The length of a name should correspond to the size of its scope.

To avoid this problem, the name of a class, method or variable should convey its purpose or intent. In the context of the application we want to model *behavior* and *data*. Object Oriented Programming suggest that both things neeedto be combined but in functional programming the opposite is true. By having this separation we can name both things in terms of their purpose in the system.

*Behaviour* represent action or a verb, whille *data* represent a noun or a thing. The rules to evolve the software architecture are based on this separation.

1. Extract a data class whenever there's data involve.
2. Define a top level namespace for the behavior, it should group the purpose in the system.
3. Add new namespace when needed, define behavior as stateless functions.


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
