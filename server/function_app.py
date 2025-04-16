import azure.functions as func
import logging
import pandas as pd
import json

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="trip_summary")
def trip_summary(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('🚗 Trip summary endpoint hit.')

    # Parse JSON
    try:
        json_payload = req.get_json()
        logging.info(f"Received payload: {json.dumps(json_payload)}")
    except ValueError:
        logging.error("❌ Invalid JSON in request body.")
        return func.HttpResponse("Invalid JSON", status_code=400)

    # Extract sensor data
    accelerometer_input = json_payload.get('accel_data')
    gyroscope_input = json_payload.get('gyro_data')

    # Log accelerometer and gyroscope data separately
    logging.info(f"Accelerometer data: {json.dumps(accelerometer_input)}")
    logging.info(f"Gyroscope data: {json.dumps(gyroscope_input)}")

    if not isinstance(accelerometer_input, list) or not isinstance(gyroscope_input, list):
        return func.HttpResponse("Invalid data format", status_code=400)

    if not accelerometer_input or not gyroscope_input:
        return func.HttpResponse("Missing accelerometer or gyroscope data", status_code=400)

    try:
        # Convert to DataFrames using 'x', 'y', 'z' columns
        accel_df = pd.DataFrame(accelerometer_input, columns=['x', 'y', 'z']).rename(columns={
            'x': 'ax',
            'y': 'ay',
            'z': 'az'
        })
        gyro_df = pd.DataFrame(gyroscope_input, columns=['x', 'y', 'z']).rename(columns={
            'x': 'gx',
            'y': 'gy',
            'z': 'gz'
        })

        full_df = pd.concat([accel_df, gyro_df], axis=1)

        if full_df.empty:
            return func.HttpResponse("No data to process.", status_code=400)

        # Apply analysis
        full_df['harsh_braking'] = full_df['ax'].apply(lambda val: val < -2.5)
        full_df['sudden_acceleration'] = full_df['ax'].apply(lambda val: val > 2.5)
        full_df['sudden_turn'] = full_df['gz'].apply(lambda val: abs(val) > 1.5)

        total_points = len(full_df)

        # Summary
        summary_data = {
            "harsh_braking": {
                "count": int(full_df['harsh_braking'].sum()),
                "percentage": f"{(full_df['harsh_braking'].sum()/total_points) * 100:.2f}%"
            },
            "sudden_acceleration": {
                "count": int(full_df['sudden_acceleration'].sum()),
                "percentage": f"{(full_df['sudden_acceleration'].sum()/total_points) * 100:.2f}%"
            },
            "sudden_turn": {
                "count": int(full_df['sudden_turn'].sum()),
                "percentage": f"{(full_df['sudden_turn'].sum()/total_points) * 100:.2f}%"
            }
        }

        return func.HttpResponse(json.dumps(summary_data), mimetype="application/json", status_code=200)

    except Exception as e:
        logging.error(f"❌ Processing error: {str(e)}")
        return func.HttpResponse("Error processing sensor data.", status_code=500)
