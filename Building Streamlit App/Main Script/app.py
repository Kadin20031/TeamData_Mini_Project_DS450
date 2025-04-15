# streamlit imports
import streamlit as st
import re
import os

#standard imports
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# classification imports
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier  # or RandomForestRegressor
from sklearn.metrics import accuracy_score  # or use appropriate metric

# creating dataframe for wine types 

wine_df = pd.read_csv('C:\\Users\\Kadin\\Documents\\Building Streamlit App\\winequality-merged-v2 (1).csv')

red_wine_df = wine_df[wine_df['color'] == 'red']
white_wine_df = wine_df[wine_df['color'] == 'white']


# title creation
col1, col2 = st.columns([1, 3])

with col2:
    st.image('https://images.photowall.com/products/47209/red-wine-pour.jpg?h=699&q=85', width=150)

with col1:
    st.markdown("# Wine Quality Viewer")

# Wine Type Selection
if "wine_type" not in st.session_state:  # selecting wine type
    st.session_state["wine_type"] = "Red"  # Default wine type

st.subheader("Select your wine type:")
col1, col2 = st.columns(2)
with col1:
    if st.button("🍷 Red Wine"):
        st.session_state['wine_type'] = "Red"

with col2:
    if st.button("🥂 White Wine"):
        st.session_state['wine_type'] = "White"

# Tab Creation
tab1, tab2, tab3, tab4, tab5, tab6, tab7 = st.tabs(["MetaData", "Data", "Color", "Quality",
 "Scatter", "Box", "Classification"])

# Metadata Tab
with tab1:
    st.header("Meta Data")
    if st.session_state["wine_type"] == "Red":
        st.write("Red wine meta data.")
        st.write(red_wine_df)
    else:
        st.write("White wine meta data.")
        st.write(white_wine_df)

# Data Tab
with tab2:
    st.header("Data")
    if st.session_state["wine_type"] == "Red":
        st.write("Red wine data.")
        filtered_df = red_wine_df  # Get filtered df
    else:
        st.write("White wine data.")
        filtered_df = white_wine_df  # Get filtered df

    # Radio button to select display mode
    display_mode = st.radio("Select display mode:", ["Chemical", "Alcohol", "Quality", "All"])

    # Display columns based on selection
    if display_mode == "Chemical":
        chemical_columns = ['color'] + [col for col in filtered_df.columns if col not in ['color', 'alcohol', 'quality']]
        st.write(filtered_df[chemical_columns])
    elif display_mode == "Alcohol":
        st.write(filtered_df[['color', 'alcohol']])
    elif display_mode == "Quality":
        st.write(filtered_df[['color', 'quality']])
    elif display_mode == "All":
        all_columns = ['color'] + [col for col in filtered_df.columns if col != 'color']
        st.write(filtered_df[all_columns])

# wine distribution tab
with tab3:
    st.header("Wine Type Distribution")

    # Get wine type counts
    wine_type_counts = wine_df['color'].value_counts()

        # Define wine colors
    wine_colors = {
        'red': '#8B0000',     # dark red for red wine
        'white': '#F5DEB3'    # soft beige for white wine
    }

    # Get corresponding colors for each bar
    colors = [wine_colors.get(w, '#333333') for w in wine_type_counts.index]

    # Create bar chart
    fig, ax = plt.subplots()
    ax.bar(wine_type_counts.index, wine_type_counts.values, color = colors,edgecolor='black' )
    ax.set_xlabel("Wine Type", fontsize=12)
    ax.set_ylabel("Count", fontsize=12)
    ax.set_title("Distribution of Red and White Wines", fontsize=14, fontweight='bold')
    plt.tight_layout()
    st.pyplot(fig)  # Display the chart using st.pyplot

# wine quality distribution
with tab4:
    st.header("Wine Quality Distribution")

    # Get wine quality counts
    wine_quality_counts = wine_df['quality'].value_counts().sort_index()

    # Create bar chart
    fig, ax = plt.subplots()
    ax.bar(wine_quality_counts.index, wine_quality_counts.values, color = 'tan', edgecolor='black')
    ax.set_xlabel("Wine Quality")
    ax.set_ylabel("Count")
    ax.set_title("Distribution of Wine Quality", fontsize=14, fontweight='bold')

    st.pyplot(fig)  # Display the chart using st.pyplot

# scatter plots
with tab5:
    st.header("Scatter Plot")

    # Column selection
    column1 = st.selectbox("Select first column:", wine_df.columns, index=0)  # Default to first column
    column2 = st.selectbox("Select second column:", wine_df.columns, index=1)  # Default to second column

    # Check if both columns are selected
    if column1 and column2:
        # Create scatter plot
        fig, ax = plt.subplots()
        ax.scatter(wine_df[column1], wine_df[column2], color = 'tan')
        ax.set_xlabel(column1)
        ax.set_ylabel(column2)
        ax.set_title(f"Scatter Plot of {column1} vs {column2}")

        st.pyplot(fig)  # Display the chart using st.pyplot
        #st.write(f"Scatter Plot of {column1} vs {column2}")

# box plot
with tab6:
    st.header("Box Plot")

    # Column selection for box plot
    column_to_plot = st.selectbox("Select column for box plot:", wine_df.columns)

    # Create box plot
    fig, ax = plt.subplots()
    ax.boxplot(wine_df[column_to_plot])
    ax.set_ylabel(column_to_plot)
    ax.set_title(f"Box Plot of {column_to_plot}")

    st.pyplot(fig)  # Display the chart using st.pyplot

# classification 
with tab7:
    st.header("Wine Quality Classification")

    # Prepare data for classification
    X = wine_df.drop('quality', axis=1)  # Features
    y = wine_df['quality']  # Target variable

    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Separate column types
    numeric_features = X_train.select_dtypes(include=['int64', 'float64']).columns
    categorical_features = X_train.select_dtypes(include=['object', 'category']).columns

    # Preprocessor
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', StandardScaler(), numeric_features),
            ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
        ]
    )

    # Full pipeline
    pipeline = Pipeline(steps=[
        ('preprocessor', preprocessor),
        ('classifier', RandomForestClassifier(random_state=42))
    ])

    # Fit model
    pipeline.fit(X_train, y_train)

    # Predict and evaluate
    y_pred = pipeline.predict(X_test)

    # Extract the trained classifier
    classifier = pipeline.named_steps['classifier']

    # Get the transformed feature names
    # First, get the names from each part of the ColumnTransformer
    num_features = numeric_features
    cat_features = pipeline.named_steps['preprocessor'].named_transformers_['cat'].get_feature_names_out(categorical_features)

    # Combine all feature names (numeric + encoded categorical)
    all_features = list(num_features) + list(cat_features)

    # Get feature importances
    importances = classifier.feature_importances_

    # Get classification report as a dict
    report_dict = classification_report(y_test, y_pred, output_dict=True)

    # Convert to DataFrame
    report_df = pd.DataFrame(report_dict).transpose().reset_index()
    report_df.rename(columns={'index': 'Class'}, inplace=True)

    # Optional: round to 3 decimal places
    report_df = report_df.round(3)

    # Display in Streamlit
    st.subheader("Classification Report")
    st.dataframe(report_df)

    # Build Feature Importance DataFrame
    feature_importance_df = pd.DataFrame({
        'Feature': all_features,
        'Importance': importances
    }).sort_values('Importance', ascending=False)

    # Plot
    fig, ax = plt.subplots(figsize=(8, 6))
    ax.barh(feature_importance_df['Feature'], feature_importance_df['Importance'], color='tan')
    ax.set_xlabel("Importance")
    ax.set_ylabel("Feature")
    ax.set_title("Feature Importance")
    plt.tight_layout()
    st.pyplot(fig)
