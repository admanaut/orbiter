import React from 'react';
import { Theme, createStyles, makeStyles } from '@material-ui/core/styles';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import { apodData } from '@/resources/apod';

interface APOD {
    url: string,
    title: string,
    media_type: string
    hdurl?: string,
    explanation: string,
    date: string,
    service_version: string,
    copyright?: string
}

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'space-around',
            overflow: 'hidden',
            backgroundColor: theme.palette.background.paper,
        },
        gridList: {
            width: 500,
            height: 450,
        },
    }),
);

export function App() {
    const classes = useStyles();

    return (
        <div className={classes.root}>
            <GridList cellHeight={160} className={classes.gridList} cols={3}>
                {apodData.map((apod: APOD) => (
                    <GridListTile key={apod.url}>
                        <img src={apod.url} alt={apod.title} />
                    </GridListTile>
                ))}
            </GridList>
        </div>
    );
}
