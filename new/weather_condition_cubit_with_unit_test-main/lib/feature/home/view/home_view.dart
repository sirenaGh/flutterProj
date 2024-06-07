import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/feature/home/enum/home_states.dart';
import 'package:weather_app/feature/home/viewmodel/home_cubit.dart';
import 'package:weather_app/feature/home/widget/sky_condition_widget.dart';
import 'package:weather_app/product/constants/color_constants.dart';
import 'package:weather_app/product/constants/space_constants.dart';
import 'package:weather_app/product/constants/string_constants.dart';
import 'package:weather_app/product/extension/responsive/responsive.dart';
import '../viewmodel/home_state.dart';

// ريتا سامر الجباعي
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: SpaceConstants.normal,
            ),
            Padding(
              padding: context.lowSymmetric,
              child: TextFormField(
                controller: context.read<HomeCubit>().cityInputController,
                onChanged: (value) {
                  // FILTER LIST
                  context.read<HomeCubit>().typeAheadFilter(value);
                  // HomeCubit(null).typeAheadFilter(value);
                },
                onTap: () {
                  context.read<HomeCubit>().changeSuggestionVisible();
                },
                style: const TextStyle(color: ColorConstants.lightGrey),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide:
                            const BorderSide(color: ColorConstants.lightGrey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: ColorConstants.primaryOrange)),
                    hintText: "Search City",
                    hintStyle: const TextStyle(
                        color: ColorConstants.hintTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: ColorConstants.lightGrey,
                    filled: true,
                    fillColor: ColorConstants.searchBoxFillColor),
                cursorColor: ColorConstants.primaryOrange,
                cursorWidth: 1.6,
                cursorHeight: 20,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            // context.watch<HomeCubit>().suggestionList.isNotEmpty || cityInputController.text.isNotEmpty
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return state.cityList == null
                    ? const Text('')
                    : (state.suggestionCityList == null ||
                            context
                                    .read<HomeCubit>()
                                    .cityInputController
                                    .text ==
                                '')
                        ? const Text('')
                        : Visibility(
                            visible: state.isListVisible,
                            child: SizedBox(
                              height: 132,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(10),
                                shrinkWrap: true,
                                itemCount: state.suggestionCityList!.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 34,
                                    child: TextButton(
                                      child: Text(
                                          (state.suggestionCityList?[index]
                                                  .name) ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      onPressed: () {
                                        context
                                            .read<HomeCubit>()
                                            .changeSuggestionVisible();
                                        context.read<HomeCubit>().fetchItem(
                                            state.suggestionCityList?[index]
                                                .latitude,
                                            state.suggestionCityList?[index]
                                                .longitude);
                                        context
                                                .read<HomeCubit>()
                                                .currentLocationCity =
                                            state.suggestionCityList?[index]
                                                .name;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
              },
            ),
            const SizedBox(
              height: SpaceConstants.small,
            ),
            SizedBox(
              width: context.dynamicWidth(0.72),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primaryOrange),
                  child: const Text("Search")),
            ),
            const SizedBox(
              height: SpaceConstants.small,
            ),
            SizedBox(
                height: context.dynamicHeight(0.78),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Center(
                        child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                          if (state.homeStates == HomeStates.initial ||
                              state.homeStates == HomeStates.loading) {
                            return const CircularProgressIndicator(
                              color: ColorConstants.darkGrey,
                            );
                          } else if (state.homeStates == HomeStates.loaded) {
                            return Column(
                              children: [
                                Text(
                                  context.read<HomeCubit>().isCurrentLocation!
                                      ? StringConstants.currentLocation
                                      : StringConstants.searchResult,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: ColorConstants.darkTextColor),
                                ),
                                const SizedBox(
                                  height: SpaceConstants.verySmall,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 15),
                                  decoration: BoxDecoration(
                                      color: ColorConstants.darkGrey,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    context
                                            .read<HomeCubit>()
                                            .currentLocationCity ??
                                        StringConstants
                                            .getCityLocationErrorText,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(
                                  height: SpaceConstants.small,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${context.read<HomeCubit>().weatherModel!.temp}C°",
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants
                                                  .regularTextColor),
                                        ),
                                        const SizedBox(
                                          width: SpaceConstants.verySmall,
                                        ),
                                        int.parse(context
                                                    .read<HomeCubit>()
                                                    .weatherModel!
                                                    .temp
                                                    .toString()) >
                                                33 //! koşulları ayır (enum + widget)
                                            ? const Icon(
                                                Icons.fire_extinguisher,
                                                color: Colors.deepOrangeAccent,
                                              )
                                            : int.parse(context
                                                        .read<HomeCubit>()
                                                        .weatherModel!
                                                        .temp
                                                        .toString()) >
                                                    12
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.greenAccent,
                                                  )
                                                : const Icon(
                                                    Icons.snowing,
                                                    color: Colors.blue,
                                                  )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: SpaceConstants.verySmall,
                                    ),
                                    Text(
                                      " (feels like : ${context.read<HomeCubit>().weatherModel!.feelsLike}C°)",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstants.lightGrey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    //! WİDGET
                                    child: SkyConditionAnimationWidget()),
                                Row(
                                  children: [
                                    Lottie.asset(
                                        "assets/animations/humidity.json",
                                        width: 40,
                                        height: 40),
                                    Text(
                                      "${context.read<HomeCubit>().weatherModel!.humidity}",
                                      style: TextStyle(
                                          color: int.parse(context
                                                      .read<HomeCubit>()
                                                      .weatherModel!
                                                      .humidity
                                                      .toString()) >
                                                  60
                                              ? Colors.blue
                                              : ColorConstants
                                                  .regularTextColor),
                                    ),
                                    const Spacer(),
                                    Lottie.asset("assets/animations/wind.json",
                                        width: 40, height: 40),
                                    Text(
                                      "${context.read<HomeCubit>().weatherModel!.windSpeed}",
                                      style: const TextStyle(
                                          color:
                                              ColorConstants.regularTextColor),
                                    ),
                                  ],
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "     Humidity",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.lightGrey),
                                    ),
                                    Text(
                                      "Wind Speed",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.lightGrey),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Sun Rise : ",
                                      style: TextStyle(
                                          color: ColorConstants.lightGrey,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      DateFormat(' kk:mm').format(
                                          context.read<HomeCubit>().sunRise!),
                                      style: const TextStyle(
                                          color: ColorConstants.lightGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Sun Set : ",
                                      style: TextStyle(
                                          color: ColorConstants.lightGrey,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      DateFormat(' kk:mm').format(
                                          context.read<HomeCubit>().sunSet!),
                                      style: const TextStyle(
                                          color: ColorConstants.lightGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const Text(
                                  "(UTC +3)",
                                  style: TextStyle(
                                      color: ColorConstants.lightGrey,
                                      fontSize: 12),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator(
                              color: ColorConstants.darkGrey,
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
