import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-series';

  final int id;

  TVSeriesDetailPage({required this.id});

  @override
  _TVSeriesDetailPageState createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TVSeriesDetailBloc>().add(SeriesDetail(widget.id));
      context
          .read<TVSeriesRecommendationsBloc>()
          .add(TVSeriesRecommendations(widget.id));
      context
          .read<TVSeriesWatchlistBloc>()
          .add(TVSeriesWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    var isAddedToWatchlist =
    context.select<TVSeriesWatchlistBloc, bool>((value) {
      var state = value.state;
      if (state is WatchlistSeriesStatus) {
        return state.status;
      }
      return false;
    });

    final recommendationSeries =
    context.select<TVSeriesRecommendationsBloc, List<TVSeries>>((value) {
      if (value.state is TVSeriesHasData) {
        return (value.state as TVSeriesHasData).result;
      } else {
        return [];
      }
    });

    return Scaffold(
      body: BlocBuilder<TVSeriesDetailBloc, TVSeriesState>(
        builder: (context, state) {
          if (state is TVSeriesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SeriesDetailHasData) {
            final detailSeries = state.detailSeries;
            return SafeArea(
              child: DetailContentSeries(
                detailSeries,
                recommendationSeries,
                isAddedToWatchlist,
              ),
            );
          } else if (state is TVSeriesError) {
            return Text(state.message);
          } else {
            return Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContentSeries extends StatelessWidget {
  final TVSeriesDetail series;
  final List<TVSeries> recommendations;
  final bool isAddedWatchlist;

  DetailContentSeries(this.series, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(
                child: CircularProgressIndicator(),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TVSeriesWatchlistBloc>()
                                      .add(TVSeriesWatchlistSave(series));
                                } else {
                                  context
                                      .read<TVSeriesWatchlistBloc>()
                                      .add(TVSeriesWatchlistRemove(series));
                                }
                                String message = '';

                                final state =
                                    BlocProvider
                                        .of<TVSeriesWatchlistBloc>(context)
                                        .state;
                                if (state is WatchlistSeriesStatus) {
                                  message = isAddedWatchlist
                                      ? TVSeriesWatchlistBloc
                                      .watchlistRemoveSuccessMessage
                                      : TVSeriesWatchlistBloc
                                      .watchlistAddSuccessMessage;
                                } else {
                                  message = isAddedWatchlist == false
                                      ? TVSeriesWatchlistBloc
                                      .watchlistAddSuccessMessage
                                      : TVSeriesWatchlistBloc
                                      .watchlistRemoveSuccessMessage;
                                }

                                if (message ==
                                    TVSeriesWatchlistBloc
                                        .watchlistAddSuccessMessage ||
                                    message ==
                                        TVSeriesWatchlistBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(milliseconds: 500),
                                          content: Text(message)));
                                  // Load new status
                                  BlocProvider.of<TVSeriesWatchlistBloc>(context)
                                      .add(TVSeriesWatchlistStatus(series.id));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(series.genres),
                            ),
                            Text(
                              _showDuration(series.numberOfEpisodes),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: series.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TVSeriesRecommendationsBloc, TVSeriesState>(
                              builder: (context, state) {
                                if (state is TVSeriesLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TVSeriesError) {
                                  return Text(state.message);
                                } else if (state is TVSeriesHasData) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final series = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVSeriesDetailPage.ROUTE_NAME,
                                                arguments: series.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'https://image.tmdb.org/t/p/w500${series
                                                    .posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                    Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
