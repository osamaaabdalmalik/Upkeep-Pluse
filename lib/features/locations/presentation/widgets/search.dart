import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upkeep_plus/features/foundations/domain/entities/filter_foundations.dart';
import 'package:upkeep_plus/features/foundations/presentation/bloc/filterFoundations/filter_foundations_bloc.dart';
import 'package:upkeep_plus/features/foundations/presentation/bloc/filterFoundationsInSystem/filter_foundations_in_system_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/region.dart';
import '../bloc/getLocations/get_locations_bloc.dart';
import '../bloc/getLocations/get_locations_event.dart';
import '../bloc/getLocations/get_locations_state.dart';
import '../../../../injection_countainer.dart' as di;

// ignore: must_be_immutable
class Searchh extends StatefulWidget {
  Function setCountryId;
  Function setRegionId;
  Function setCityId;
  int? subServiceId;
  bool filterF;
  Searchh({
    Key? key,
    required this.filterF,
    required this.setCountryId,
    required this.setRegionId,
    required this.setCityId,
    this.subServiceId,
  }) : super(key: key);

  @override
  State<Searchh> createState() => _SearchhState();
}

class _SearchhState extends State<Searchh> {
  TextEditingController searchController = TextEditingController();
  bool full = false;
  Country? _selectedCountry;
  Region? _selectedRegion;
  City? _selectedCity;
  int? countryId;
  int? cityId;
  int? regionId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double totalWidth = (390 / 390) * width;
    double searchWidth = (252.65 / 390) * totalWidth;
    return BlocProvider(
      create: (context) {
        return di.sl<GetLocationsBloc>()..add(const GetAllCountryEvent());
      },
      child: Container(
        width: totalWidth,
        height: (45 / 390) * totalWidth,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: const EdgeInsets.only(top: 72),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GetLocationsBloc, GetLocationsState>(
              builder: (context, state) {
                if (state is LoadingGetLocationsState) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: secondryColor,
                      ),
                    ),
                  );
                } else if (state is LoadedGetAllCountryState) {
                  return buildDropdownButton(
                    state.country,
                    widget.setCountryId,
                    widget.setRegionId,
                    widget.setCityId,
                  );
                } else if (state is FailureGetLocationsState) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<GetLocationsBloc>()
                            .add(const GetAllCountryEvent());
                      },
                      icon: const Icon(
                        Icons.replay_sharp,
                        color: secondryColor,
                      ),
                    ),
                  );
                }
                return const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black54,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Container(
              width: searchWidth,
              height: (38.59 / 252.65) * searchWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: widget.filterF
                    ? BlocProvider<FilterFoundationsInSystemBloc>(
                        create: (_) => di.sl<FilterFoundationsInSystemBloc>(),
                        child: Stack(
                          children: [
                            TextFormField(
                              scrollController: ScrollController(),
                              controller: searchController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: SizedBox(),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black12,
                                child: IconButton(
                                  splashColor: primaryColor,
                                  icon: const Icon(Icons.search,
                                      color: primaryColor),
                                  onPressed: () {
                                    context
                                        .read<FilterFoundationsInSystemBloc>()
                                        .add(
                                          LoadedFilterFoundationsInSystemEvent(
                                            filterFoundations:
                                                FilterFoundations(
                                              countryId: countryId,
                                              cityId: cityId,
                                              regionId: regionId,
                                              subServiceId: widget.subServiceId,
                                            ),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : BlocProvider<FilterServicesFoundationsBloc>(
                        create: (_) => di.sl<FilterServicesFoundationsBloc>(),
                        child: Stack(
                          children: [
                            TextFormField(
                              scrollController: ScrollController(),
                              controller: searchController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: SizedBox(),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black12,
                                child: IconButton(
                                  splashColor: primaryColor,
                                  icon: const Icon(Icons.search,
                                      color: primaryColor),
                                  onPressed: () {
                                    context
                                        .read<FilterServicesFoundationsBloc>()
                                        .add(
                                          LoadedFilterServicesFoundationsEvent(
                                            filterFoundations:
                                                FilterFoundations(
                                              countryId: countryId,
                                              cityId: cityId,
                                              regionId: regionId,
                                              subServiceId: widget.subServiceId,
                                            ),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<City> getCitiesByCountryId(int countryId, List<Country> countryList) {
    return countryList.firstWhere((c) => c.id == countryId).cities;
  }

  List<Region> getRegionsByCityId(int cityId, List<City> cityList) {
    return cityList.firstWhere((c) => c.id == cityId).regions;
  }

  Widget buildDropdownButton(
    List<Country> countryList,
    Function setCountryId,
    Function setRegionId,
    Function setCityId,
  ) {
    return PopupMenuButton<String>(
      elevation: 0,
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) {
        if (_selectedCountry == null) {
          return countryList.map((country) {
            return PopupMenuItem(
              value: 'country-${country.id}',
              child: Text(country.name),
            );
          }).toList();
        } else if (_selectedCity == null) {
          final cities =
              getCitiesByCountryId(_selectedCountry!.id, countryList);
          return cities.map((city) {
            return PopupMenuItem(
              value: 'city-${city.id}',
              child: Text(city.name),
            );
          }).toList();
        } else {
          final regions =
              getRegionsByCityId(_selectedCity!.id, _selectedCountry!.cities);
          return regions.map((region) {
            return PopupMenuItem(
              value: 'region-${region.id}',
              child: Text(region.name),
            );
          }).toList();
        }
      },
      onSelected: (value) {
        final parts = value.split('-');
        final type = parts[0];
        final id = int.parse(parts[1]);

        setState(() {
          if (type == 'country') {
            _selectedCountry = countryList.firstWhere((c) => c.id == id);
            _selectedCity = null;
            _selectedRegion = null;
            countryId = id;
            setCountryId(id);
            searchController.text = _selectedCountry!.name;
          } else if (type == 'city') {
            _selectedCity =
                getCitiesByCountryId(_selectedCountry!.id, countryList)
                    .firstWhere((c) => c.id == id);
            _selectedRegion = null;
            cityId = id;
            setCityId(id);
            searchController.text =
                '${_selectedCountry!.name} > ${_selectedCity!.name}';
          } else if (type == 'region') {
            _selectedRegion =
                getRegionsByCityId(_selectedCity!.id, _selectedCountry!.cities)
                    .firstWhere((r) => r.id == id);
            regionId = id;
            setRegionId(id);
            searchController.text =
                '${_selectedCountry!.name} > ${_selectedCity!.name} > ${_selectedRegion!.name}';
            full = true;
          }
        });
      },
      child: StatefulBuilder(builder: (context, state) {
        return CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: full
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      full = false;
                    });
                    countryId = null;
                    cityId = null;
                    regionId = null;
                    _selectedCountry = null;
                    _selectedRegion = null;
                    _selectedCity = null;
                    searchController.text = '';
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: primaryColor,
                  ),
                )
              : const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black54,
                ),
        );
      }),
    );
  }
}
