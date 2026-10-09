from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel


# =========================================================
# APPLICATION
# =========================================================

app = FastAPI(
    title="IRTC Railway Management API",
    version="1.0.0"
)


# =========================================================
# CORS
# =========================================================

app.add_middleware(
    CORSMiddleware,

    allow_origins=["*"],

    allow_credentials=False,

    allow_methods=["*"],

    allow_headers=["*"],
)


# =========================================================
# LOGIN MODEL
# =========================================================

class LoginRequest(BaseModel):

    user_id: str

    password: str

    branch: str


# =========================================================
# ROOT
# =========================================================

@app.get("/")
def root():

    return {

        "status": "online",

        "application":
            "IRTC Railway Management API",

        "version": "1.0.0"
    }


# =========================================================
# LOGIN
# =========================================================

@app.post("/login")
def login(data: LoginRequest):

    users = {

        "TRACK123": {

            "user_id":
                "track01",

            "password":
                "1234",

            "branch":
                "Track Detector"
        },


        "MENTOR123": {

            "user_id":
                "mentor01",

            "password":
                "5678",

            "branch":
                "Track Mentor"
        },


        "WATER123": {

            "user_id":
                "water01",

            "password":
                "9012",

            "branch":
                "Water Management"
        }
    }


    valid_branches = [

        "Track Detector",

        "Track Mentor",

        "Water Management"
    ]


    if data.branch not in valid_branches:

        return {

            "success":
                False,

            "message":
                "Invalid branch"
        }


    for passkey, user in users.items():

        if (

            data.user_id ==
                user["user_id"]

            and

            data.password ==
                user["password"]

            and

            data.branch ==
                user["branch"]

        ):

            return {

                "success":
                    True,

                "message":
                    "Login successful",

                "user_id":
                    user["user_id"],

                "branch":
                    user["branch"],

                "passkey":
                    passkey
            }


    return {

        "success":
            False,

        "message":
            "Invalid User ID, Password or Branch"
    }


# =========================================================
# TRACK DEFECTS
# =========================================================

@app.get("/track-defects")
def get_track_defects():

    return {

        "success":
            True,

        "module":
            "Track Detector",

        "data": {

            "region":
                "Southern Railway",

            "track_age_years":
                14,

            "internal_flaw_count":
                7,

            "repair_cost_lakhs":
                18.5,

            "danger_level":
                True,


            "defects": [

                {

                    "id":
                        1,

                    "location":
                        "KM 12.450",

                    "type":
                        "Internal Rail Crack",

                    "severity":
                        "High",

                    "status":
                        "Requires Inspection"
                },


                {

                    "id":
                        2,

                    "location":
                        "KM 18.720",

                    "type":
                        "Surface Defect",

                    "severity":
                        "Medium",

                    "status":
                        "Monitoring"
                },


                {

                    "id":
                        3,

                    "location":
                        "KM 24.130",

                    "type":
                        "Rail Wear",

                    "severity":
                        "Low",

                    "status":
                        "Normal"
                }
            ]
        }
    }


# =========================================================
# TRACK SECTIONS
# =========================================================

@app.get("/track-sections")
def get_track_sections():

    return {

        "success":
            True,

        "module":
            "Track Mentor",


        "divisions": [

            {

                "name":
                    "Chennai Division",

                "code":
                    "MAS",


                "sections": [

                    {

                        "id":
                            "MAS-AJJ-01",

                        "name":
                            "Chennai Central - Arakkonam",

                        "sub_section":
                            "KM 24.50 to KM 68.20",

                        "laid_year":
                            2013,

                        "age_years":
                            13,

                        "rail_type":
                            "60 kg/m UIC 90 UTS",

                        "sleeper_type":
                            "PSC",

                        "annual_usage_gmt":
                            48.6,

                        "daily_train_count":
                            94,

                        "passenger_trains":
                            66,

                        "freight_trains":
                            28,

                        "health_score":
                            84,


                        "maintenance_cost_history": [

                            {
                                "year":
                                    "2022",

                                "building_capex_cr":
                                    5.6,

                                "repair_cost_cr":
                                    2.5
                            },

                            {
                                "year":
                                    "2023",

                                "building_capex_cr":
                                    7.4,

                                "repair_cost_cr":
                                    2.9
                            },

                            {
                                "year":
                                    "2024",

                                "building_capex_cr":
                                    3.0,

                                "repair_cost_cr":
                                    3.6
                            },

                            {
                                "year":
                                    "2025",

                                "building_capex_cr":
                                    8.9,

                                "repair_cost_cr":
                                    3.8
                            },

                            {
                                "year":
                                    "2026",

                                "building_capex_cr":
                                    2.2,

                                "repair_cost_cr":
                                    1.4
                            }
                        ],


                        "maintenance_logs": [

                            "Deep Ballast Screening - Nov 2025",

                            "Ultrasonic Flaw Detection - Jan 2026",

                            "Flash Butt Welding - Feb 2026"
                        ]
                    },


                    {

                        "id":
                            "MAS-GDR-02",

                        "name":
                            "Chennai Beach - Gummidipundi",

                        "sub_section":
                            "KM 12.00 to KM 46.80",

                        "laid_year":
                            2016,

                        "age_years":
                            10,

                        "rail_type":
                            "60 kg/m 110 UTS",

                        "sleeper_type":
                            "PSC",

                        "annual_usage_gmt":
                            38.2,

                        "daily_train_count":
                            78,

                        "passenger_trains":
                            52,

                        "freight_trains":
                            26,

                        "health_score":
                            91,


                        "maintenance_cost_history": [

                            {
                                "year":
                                    "2023",

                                "building_capex_cr":
                                    4.5,

                                "repair_cost_cr":
                                    1.8
                            },

                            {
                                "year":
                                    "2025",

                                "building_capex_cr":
                                    2.1,

                                "repair_cost_cr":
                                    2.4
                            },

                            {
                                "year":
                                    "2026",

                                "building_capex_cr":
                                    1.0,

                                "repair_cost_cr":
                                    0.9
                            }
                        ],


                        "maintenance_logs": [

                            "Turnout Renewal - Sep 2025",

                            "Automated Track Tamping - Dec 2025"
                        ]
                    }
                ]
            },


            {

                "name":
                    "Palakkad Division",

                "code":
                    "PGT",


                "sections": [

                    {

                        "id":
                            "PGT-SRR-01",

                        "name":
                            "Palakkad - Shoranur",

                        "sub_section":
                            "KM 520.00 to KM 568.50",

                        "laid_year":
                            2010,

                        "age_years":
                            16,

                        "rail_type":
                            "52 kg/m 90 UTS",

                        "sleeper_type":
                            "PSC",

                        "annual_usage_gmt":
                            32.4,

                        "daily_train_count":
                            62,

                        "passenger_trains":
                            44,

                        "freight_trains":
                            18,

                        "health_score":
                            76,


                        "maintenance_cost_history": [

                            {
                                "year":
                                    "2022",

                                "building_capex_cr":
                                    6.2,

                                "repair_cost_cr":
                                    3.5
                            },

                            {
                                "year":
                                    "2024",

                                "building_capex_cr":
                                    4.8,

                                "repair_cost_cr":
                                    4.2
                            },

                            {
                                "year":
                                    "2026",

                                "building_capex_cr":
                                    3.1,

                                "repair_cost_cr":
                                    2.8
                            }
                        ],


                        "maintenance_logs": [

                            "Rail Stress Relieving - Aug 2025",

                            "Shoulder Ballast Cleaning - Jan 2026"
                        ]
                    }
                ]
            },


            {

                "name":
                    "Thiruvananthapuram Division",

                "code":
                    "TVC",


                "sections": [

                    {

                        "id":
                            "TVC-ERS-01",

                        "name":
                            "Ernakulam - Kollam",

                        "sub_section":
                            "KM 60.10 to KM 142.00",

                        "laid_year":
                            2014,

                        "age_years":
                            12,

                        "rail_type":
                            "60 kg/m UIC",

                        "sleeper_type":
                            "PSC",

                        "annual_usage_gmt":
                            29.5,

                        "daily_train_count":
                            56,

                        "passenger_trains":
                            46,

                        "freight_trains":
                            10,

                        "health_score":
                            88,


                        "maintenance_cost_history": [

                            {
                                "year":
                                    "2023",

                                "building_capex_cr":
                                    3.8,

                                "repair_cost_cr":
                                    2.2
                            },

                            {
                                "year":
                                    "2025",

                                "building_capex_cr":
                                    6.0,

                                "repair_cost_cr":
                                    2.7
                            }
                        ],


                        "maintenance_logs": [

                            "Corrosion Protection - Oct 2025",

                            "Track Geometry Recording - Jan 2026"
                        ]
                    }
                ]
            },


            {

                "name":
                    "Madurai Division",

                "code":
                    "MDU",


                "sections": [

                    {

                        "id":
                            "MDU-DG-01",

                        "name":
                            "Madurai - Dindigul",

                        "sub_section":
                            "KM 430.00 to KM 492.00",

                        "laid_year":
                            2018,

                        "age_years":
                            8,

                        "rail_type":
                            "60 kg/m 90 UTS",

                        "sleeper_type":
                            "PSC",

                        "annual_usage_gmt":
                            26.8,

                        "daily_train_count":
                            48,

                        "passenger_trains":
                            36,

                        "freight_trains":
                            12,

                        "health_score":
                            94,


                        "maintenance_cost_history": [

                            {
                                "year":
                                    "2022",

                                "building_capex_cr":
                                    3.5,

                                "repair_cost_cr":
                                    0.9
                            },

                            {
                                "year":
                                    "2024",

                                "building_capex_cr":
                                    2.2,

                                "repair_cost_cr":
                                    1.4
                            },

                            {
                                "year":
                                    "2026",

                                "building_capex_cr":
                                    1.8,

                                "repair_cost_cr":
                                    1.1
                            }
                        ],


                        "maintenance_logs": [

                            "Routine USFD Rail Flaw Testing - Dec 2025",

                            "Point & Crossing Overhaul - Feb 2026"
                        ]
                    }
                ]
            }
        ]
    }


# =========================================================
# WATER BOREWELLS
# =========================================================

@app.get("/water/borewells")
def get_borewells():

    return {

        "success":
            True,

        "module":
            "Water Management",


        "borewells": [

            {

                "id":
                    "TRI-01",

                "location":
                    "Trichy Station",

                "water_level":
                    42.5,

                "status":
                    "Normal",

                "daily_usage":
                    18500,

                "groundwater_trend":
                    "Stable"
            },


            {

                "id":
                    "TRI-02",

                "location":
                    "Trichy Yard",

                "water_level":
                    38.2,

                "status":
                    "Warning",

                "daily_usage":
                    22100,

                "groundwater_trend":
                    "Declining"
            },


            {

                "id":
                    "TRI-03",

                "location":
                    "Trichy Depot",

                "water_level":
                    51.8,

                "status":
                    "Normal",

                "daily_usage":
                    16200,

                "groundwater_trend":
                    "Stable"
            },


            {

                "id":
                    "TRI-04",

                "location":
                    "Lalgudi",

                "water_level":
                    29.7,

                "status":
                    "Critical",

                "daily_usage":
                    24800,

                "groundwater_trend":
                    "Rapidly Declining"
            },


            {

                "id":
                    "TRI-05",

                "location":
                    "Srirangam",

                "water_level":
                    46.3,

                "status":
                    "Normal",

                "daily_usage":
                    17400,

                "groundwater_trend":
                    "Stable"
            },


            {

                "id":
                    "TRI-06",

                "location":
                    "Manapparai",

                "water_level":
                    34.9,

                "status":
                    "Warning",

                "daily_usage":
                    20700,

                "groundwater_trend":
                    "Declining"
            }
        ]
    }


# =========================================================
# WATER SUMMARY
# =========================================================

@app.get("/water/summary")
def get_water_summary():

    return {

        "success":
            True,

        "total_borewells":
            6,

        "normal":
            3,

        "warning":
            2,

        "critical":
            1,

        "total_daily_usage":
            119700,

        "average_water_level":
            40.57
    }
